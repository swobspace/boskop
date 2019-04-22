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
  #   * :always  - update record unconditionally
  #
  # hint: lastseen is always updated if newer
  #
  def initialize(options = {})
    options.symbolize_keys!
    @csvfile = get_file(options)
    @update  = options.fetch(:update) { :newer }.to_sym
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
      hc = Hosts::Creator.new(mode: update, attributes: row.to_hash)
      if hc.save
         hosts << hc.host
      else
         errors << "#{host.errors.full_messages.join(', ')}" if host.errors.any?
         success = false
      end
    end
    return_result =  Result.new(success: success, error_message: errors, hosts: hosts)
  end

private
  attr_reader :csvfile, :update

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
