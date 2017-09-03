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
    @xmlfile = options.fetch(:file).to_s
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
      host = Host.create_with(attributes(nmaphost)).find_or_create_by(ip: nmaphost.ip)
      if host.persisted? && host.update_attributes(attributes_for_update(nmaphost, host))
        hosts << host
      else
        errors << "#{host.errors.messages.join(', ')}" if host.errors.any?
        success = false
      end
    end
    return_result =  Result.new(success: success, error_message: errors, hosts: hosts)
  end

private
  attr_reader :xmlfile, :update

  # extract attributes for Host.new
  def attributes(nmaphost)
    nmaphost.attributes.reject do |k,v| 
      (k == :ip) || !(Host.attribute_names.include?(k.to_s))
    end
  end

  def attributes_for_update(nmaphost, host)
    recently_seen = (nmaphost.lastseen.to_date > host.lastseen) ? 
                    { lastseen: nmaphost.lastseen.to_date } : {}
    result = case update.to_sym
    when :none
      {}
    when :missing
      if 4.week.after(nmaphost.lastseen.to_date) >= host.lastseen
        attributes(nmaphost).select {|k,v| host.send(k).blank?}
      else
        {}
      end
    when :newer
      if nmaphost.lastseen.to_s >= host.lastseen.to_s
        attributes(nmaphost)
      else
        {}
      end
    else
      raise KeyError, ":update should be one of :none, :missing, :newer (was #{update})"
    end
    result.merge(recently_seen)
  end

end
