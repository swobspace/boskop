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
      host = Host.find_or_create_by!(ip: report.ip) do |c|
               c.lastseen = report.lastseen
               c.name     = report.name
               c.mac      = report.mac
               c.raw_os   = report.raw_os
               c.fqdn     = report.fqdn
             end
      if host.lastseen.to_date < report.lastseen.to_date
        host.update(lastseen: report.lastseen)
      end
      hosts << host
      # find or create vulnerability_detail
#      vulndetail = VulnerabilityDetail.
#                     create_with(vd_attributes(result)).
#                     find_or_create_by(nvt: result.nvt)
#      vulnerability_details << vulndetail
#
#      # create or update vulnerability record
#      vuln = Vulnerability.
#               create_with(lastseen: result.lastseen).
#               find_or_create_by(
#                 host_id: host.id, 
#                 vulnerability_detail_id: vulndetail.id
#               )
#      if vuln.lastseen.to_date < result.lastseen.to_date
#        vuln.update(lastseen: result.lastseen)
#      end
#      vulnerabilities << vuln
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
  attr_reader :xmlfile

  # extract vulnerability detail attributes for Host.new
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
