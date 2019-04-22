# import nmap scan results in xml
class ImportNmapXmlService
  Result = ImmutableStruct.new( :success?, :error_message, :hosts )

  # service = ImportNmapXmlService.new(file: 'xmlfile', update: :none)
  #
  # mandatory options:
  # * :file   - nmap xml file
  #
  # optional parameters:
  # * :update - how to update existing data. Possible values are :none (default), 
  #             :missing, :always
  #   * :none    - don't update existing records
  #   * :missing - update only missing records if xml data not older than 4 weeks
  #   * :newer   - always update record if xml data is newer than lastseen
  #
  # hint: lastseen is always updated if newer
  #
  def initialize(options = {})
    options.symbolize_keys!
    @xmlfile = get_file(options)
    @update  = options.fetch(:update) { :none }
  end

  # service.call()
  # 
  def call
    hosts = []
    errors = []
    success = true

    nmap_xml = Boskop::NMAP::XML.new(file: xmlfile)
    unless nmap_xml.valid?
      return Result.new(success: false, 
                        error_message: nmap_xml.error_message, 
                        hosts: hosts)
    end

    nmap_xml.all_hosts.each do |nmaphost|
      hc = Hosts::Creator.new(mode: update, attributes: nmaphost.attributes)
      if hc.save
        hosts << hc.host
      else
        errors << "#{host.errors.messages.join(', ')}" if host.errors.any?
        success = false
      end
    end
    return_result =  Result.new(success: success, error_message: errors, hosts: hosts)
  end

private
  attr_reader :xmlfile, :update

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
