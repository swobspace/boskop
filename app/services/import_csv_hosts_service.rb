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
    @csvfile = options.fetch(:file)
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
      csvattributes = attributes(row)
      host = Host.create_with(csvattributes).find_or_create_by(ip: csvattributes[:ip])
      if host.persisted? && host.update_attributes(attributes_for_update(csvattributes, host))
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
  def attributes(row)
    row.to_hash.symbolize_keys
  end

  def attributes_for_update(csvattributes, host)
    recently_seen = (csvattributes[:lastseen].to_date > host.lastseen) ? 
                    { lastseen: csvattributes[:lastseen].to_date } : {}
    result = case update
    when :none
      {}
    when :missing
      if 4.week.after(csvattributes[:lastseen].to_date) >= host.lastseen
        csvattributes.select {|k,v| host.send(k).blank?}
      else
        {}
      end
    when :newer
      if csvattributes[:lastseen].to_s >= host.lastseen.to_s
        csvattributes
      else
        {}
      end
    else
      raise KeyError, ":update should be one of :none, :missing, :newer (was #{update})"
    end
    result.merge(recently_seen)
  end

end
