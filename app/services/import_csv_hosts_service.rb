# import csv data
#
# column headers may be:
#
# * plain attributes setting values direct like :name or :tag
# * assoziation id like host_category_id
# * merkmal_<tag>: tag must match exactly one Merkmalklasse
#
# in case of assoziation id there are two possible values:
#
# * integer: must match the id of the assoziation
# * string: must match :name, :tag or :lid (in case of location)
#
require 'csv'
class ImportCsvHostsService
  Result = ImmutableStruct.new( :success?, :error_message, :hosts )

  # service = ImportCsvHostsService.new(file: 'csvfile', update: :none)
  #
  # mandatory options:
  # * :file   - csv import file
  #
  # optional parameters:
  # * :update - how to update existing data. Possible values are :none (default),
  #             :missing, :always
  #   * :none    - don't update existing records
  #   * :missing - update only missing records if csv data not older than 4 weeks
  #   * :newer   - always update record if csv data is newer than lastseen
  #
  # hint: lastseen is always updated if newer
  #
  def initialize(options = {})
    options.symbolize_keys!
    @csvfile = get_file(options)
    @update  = options.fetch(:update) { :none }.to_sym
  end

  # service.call()
  #
  def call
    hosts = []
    errors = []
    success = true
    unless File.readable?(csvfile)
      message = "File #{csvfile} is not readable or does not exist"
      return Result.new(success: false, error_message: message, hosts: hosts)
    end
    CSV.foreach(csvfile, headers: true, converters: :all, col_sep: ';') do |row|
      csvattributes = attributes(host_attributes,row)
      host = Host.create_with(csvattributes).find_or_create_by(ip: csvattributes[:ip])
      if host.persisted? && host.update_attributes(attributes_for_update(csvattributes, host))
         update_merkmale(host, row)
         hosts << host
      else
         errors << "#{host.errors.full_messages.join(', ')}" if host.errors.any?
         success = false
      end
    end
    return_result =  Result.new(success: success, error_message: errors, hosts: hosts)
  end

private
  attr_reader :csvfile, :update

  # extract attributes for Host.new
  def attributes(allowed_attributes, row)
    attributes = row.to_hash.symbolize_keys.select {|k,v| allowed_attributes.include?(k)}
    attributes = attributes.reject {|k,v| v.blank?}
    cleanup(attributes)
  end

  def attributes_for_update(csvattributes, host)
    seen = csvattributes[:lastseen].to_date
    recently_seen = (seen > host.lastseen) ?
                    { lastseen: seen.to_s } : {}
    result = case update
    when :none
      {}
    when :missing
      if 4.week.after(seen) >= host.lastseen
        csvattributes.select {|k,v| host.send(k).blank?}
      else
        {}
      end
    when :newer
      if seen >= host.lastseen
        csvattributes
      else
        {}
      end
    else
      raise KeyError, ":update should be one of :none, :missing, :newer (was #{update})"
    end
    result.merge(recently_seen)
  end

  def update_merkmale(host, row)
    seen = attributes([:lastseen], row)[:lastseen].to_date
    Rails.logger.debug("DEBUG: #{merkmal_attributes.inspect}")
    attributes(merkmal_attributes, row).each do |key,value|
      Rails.logger.debug("DEBUG: #{host.ip} #{key}: #{value} #{seen} #{host.lastseen} #{update}")
      if ((seen >= host.lastseen && update == :newer) || host.send(key).blank? )
        Rails.logger.debug("DEBUG: update #{host.ip.to_s}: #{key}, #{value}")
        host.send("#{key}=", value)
      end
    end
  end

  def host_attributes
    Host.attribute_names.map(&:to_sym).reject do |k|
      [:id, :created_at, :updated_at].include?(k)
    end
  end

  def merkmal_attributes
    Merkmalklasse.where(for_object: 'Host').pluck(:tag).map {|t| "merkmal_#{t}".to_sym }
  end

  # cleanup attributes:
  # * remove prefix or suffixes
  # * search for matching objects in relations if attribute =~ /_id\z/
  #
  def cleanup(attributes)
    attributes[:cpe].to_s.sub!(/cpe:/, '')
    attributes.keys.grep(/_id\z/).map(&:to_sym).each do |attr|
      attributes[attr] = search_for_id(attributes, attr)
    end
    attributes
  end

  def search_for_id(attributes, key)
    myklass = key.to_s.sub(/_id\z/,'').camelize.constantize
    value   = attributes.fetch(key, nil)
    return nil unless value.present?
    # search for id
    if value.to_i > 0
      myklass.where(id: value).first&.id
    # search for field with exact string value match
    elsif value.kind_of? String
      search_string = []
      ['tag', 'name', 'lid'].each do |attr|
        if myklass.attribute_names.include?(attr)
          search_string << "#{attr} ILIKE :search"
        end
      end
      myklass.where(search_string.join(' or '), search: "#{value}").first&.id
    else
      nil
    end
  end

  # file may be ActionDispatch::Http::UploadedFile
  #
  def get_file(options)
    file = options.fetch(:file)
    if file.respond_to?(:path)
      file.path
    else
      file.to_s
    end
  end
end
