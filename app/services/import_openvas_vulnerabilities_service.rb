# import nmap scan results in xml
class ImportOpenvasVulnerabilitiesService
  Result = ImmutableStruct.new( :success?, :error_message, :vulnerabilities, :vulnerability_details, :hosts )

  # service = ImportOpenvasVulnerabilitiesService.new(file: 'xmlfile')
  #
  # mandatory options:
  # * :file   - openvas xml file
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

    xml = Boskop::OpenVAS::XML.new(file: xmlfile)
    unless xml.valid?
      return Result.new( 
               success: false, 
               error_message: xml.error_message, 
               vulnerabilities: [], 
               vulnerability_details: [],
               hosts: []
             )
    end

    xml.results.each do |result|
      # find or create host
      host = Host.create_with(lastseen: result.lastseen).
                  find_or_create_by!(ip: result.host)
      hosts << host
      # find or create vulnerability_detail
      vulndetail = VulnerabilityDetail.
                     create_with(vd_attributes(result)).
                     find_or_create_by(nvt: result.nvt)
      vulnerability_details << vulndetail

      # create or update vulnerability record
      vuln = Vulnerability.
               create_with(lastseen: result.lastseen).
               find_or_create_by(
                 host_id: host.id, 
                 vulnerability_detail_id: vulndetail.id
               )

      unless vuln.lastseen.to_date == result.lastseen.to_date
        vuln.update(lastseen: result.lastseen)
      end
      vulnerabilities << vuln
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
