# import nmap scan results in xml
class ImportNmapXmlService
  Result = ImmutableStruct.new( :success?, :error_message, :hosts )

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
  def initialize(options = {})
    options.symbolize_keys!
    @xmlfile = options.fetch(:file)
  end

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
      host = Host.create_with(attributes(nmaphost)).find_or_create_by(ip: nmaphost.ip)
      if host.persisted?
        hosts << host
      else
        errors << "#{host.errors.messages.join(', ')}" if host.errors.any?
        success = false
      end
    end
    return_result =  Result.new(success: success, error_message: errors, hosts: hosts)
  end

private
  attr_reader :xmlfile

  # extract attributes for Host.new
  def attributes(nmaphost)
    nmaphost.attributes.reject do |k,v| 
      (k == :ip) || !(Host.attribute_names.include?(k.to_s))
    end
  end

end
