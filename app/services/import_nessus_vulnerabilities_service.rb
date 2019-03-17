# import nmap scan results in xml
class ImportNessusVulnerabilitiesService
  Result = ImmutableStruct.new( :success?, :error_message, :vulnerabilities, :vulnerability_details, :hosts )

  # service = ImportNessusVulnerabilitiesService.new(file: 'xmlfile')
  #
  # mandatory options:
  # * :file   - nessus xml file
  #
  def initialize(options = {})
    options.symbolize_keys!
    @xmlfile = get_file(options)
    if Boskop.graylog_host
      @notifier = GELF::Notifier.new(Boskop.graylog_host, 12201) 
    else
      @notifier = nil
    end
  end

  # service.call()
  # 
  def call
    vulnerabilities = []
    vulnerability_details = []
    hosts = []
    errors = []
    success = true

    xml = Boskop::Nessus::XML.new(file: xmlfile)
    unless xml.valid?
      return Result.new( 
               success: false, 
               error_message: xml.error_message, 
               vulnerabilities: [], 
               vulnerability_details: [],
               hosts: []
             )
    end

    xml.host_reports.each do |report|
      # find or create host
      host = Host.create_with(host_attributes(report)).find_or_create_by!(ip: report.ip)
      if host.lastseen.to_date < report.lastseen.to_date
        host.update(host_attributes(report))
      end
      hosts << host
      # find or create vulnerability_detail
      report.report_items.each do |item|

        next if item.threat == "None"
        vulndetail = VulnerabilityDetail.
                     create_with(vd_attributes(item)).
                     find_or_create_by(nvt: item.nvt)
        if vulndetail.errors.any?
          success = false
          errors << vulndetail.errors.full_messages.join(', ')
        else
          vulnerability_details << vulndetail
        end

        # create or update vulnerability record
        vuln = Vulnerability.
                 create_with(lastseen: report.lastseen).
                 find_or_create_by(
                   host_id: host.id, 
                   vulnerability_detail_id: vulndetail.id
                 )
        if vuln.errors.any?
          success = false
          errors << vuln.errors.full_messages.join(', ')
        else
          if vuln.lastseen.to_date < report.lastseen.to_date
            vuln.update(lastseen: report.lastseen)
          end
          vulnerabilities << vuln
          notifier.notify(vuln.to_gelf) if notifier
        end
      end
    end
    return_result =  Result.new(
                       success: success, 
                       error_message: errors,
                       vulnerabilities: vulnerabilities,
                       vulnerability_details: vulnerability_details.uniq,
                       hosts: hosts.sort.uniq
                     )
  end

private
  attr_reader :xmlfile, :notifier

  #
  # extract host attributes
  #
  def host_attributes(report)
    csp_attributes(report).merge(report.attributes).
      reject do |k,v| 
        !(Host.attribute_names.include?(k.to_s))
      end
  end

  #
  # get attributes from plugin 48337 WMI Computer System Product
  #
  def csp_attributes(report)
    Boskop::Nessus::ComputerSystemProduct.new(report_host: report)&.attributes || {}
  end

  #
  # extract vulnerability detail attributes for Host.new
  #
  def vd_attributes(result)
    result.attributes.reject do |k,v| 
      !(VulnerabilityDetail.attribute_names.include?(k.to_s))
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
