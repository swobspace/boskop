# import csv data
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
    @update  = options.fetch(:update) { :none }
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
    CSV.foreach(csvfile, headers: true, col_sep: ';') do |row|
      csvattributes     = attributes(host_attributes,row)
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
    attributes[:cpe].to_s.sub!(/cpe:/, '')
    attributes
  end

  def attributes_for_update(csvattributes, host)
    seen = csvattributes[:lastseen].to_date
    recently_seen = (seen > host.lastseen) ? 
                    { lastseen: seen.to_s } : {}
    result = case update.to_sym
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
    attributes(merkmal_attributes, row).each do |key,value|
      host.send("#{key}=", value) if host.send(key).blank?
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
