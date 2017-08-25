# import nmap scan results in xml
class ImportNmapXmlService
  Result = ImmutableStruct.new( :success?, :error_message, :hosts )

  # mandatory options:
  # +file+:: nmap xml file
  #
  def initialize(options = {})
    options.symbolize_keys!
    @xmlfile = options.fetch(:file)
  end

  def call
    hosts = []
    nmap_xml = Boskop::NMAP::XML.new(file: xmlfile)
    unless nmap_xml.valid?
      return Result.new(success: false, error_message: nmap_xml.error_message, hosts: hosts)
    end
    errors = []
    success = true

    nmap_xml.all_hosts.each do |nmaphost|
      attributes = nmaphost.attributes.delete_if {|k,v| k == :ip}
      host = Host.create_with(attributes).find_or_create_by(ip: nmaphost.ip)
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

end
