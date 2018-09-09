# import nmap scan results in xml
class DownloadNessusScanService
  Result = ImmutableStruct.new( :success?, :error_message, :xmlfile )

  # service = DownloadNessusScanService.new(nessus_id: <number>)
  #
  # mandatory options:
  # * :nessus_id   - nessus id of scan
  #
  def initialize(options = {})
    options.symbolize_keys!
    @nessus_id = options.fetch(:nessus_id).to_i
  end

  # service.call()
  # 
  def call
    if scan.blank?
      return Result.new( success: false, error_message: "no matching scan found",
                         xmlfile: nil )
    end
    xmlfile = File.join(Rails.root, 'tmp', "#{scan.uuid}.nessus")

    begin
      nessus.report_download_file(scan.nessus_id, 'nessus', xmlfile)
      if !File.readable?(xmlfile)
        raise RuntimeError, "file #{xmlfile} is not readable or does not exist"
      else
        @xmldoc  = File.open(xmlfile) { |f| Nokogiri::XML(f) }
        unless valid?
          raise RuntimeError, "can't parse #{xmlfile}, may be wrong version or not an nessus xml v2 file"
        end
      end
      return Result.new( success: true, error_message: nil, xmlfile: xmlfile )

    rescue StandardError => e
      File.unlink xmlfile if File.exist?(xmlfile)
      return Result.new( success: false, xmlfile: nil,
                         error_message: e.message)
    end
  end

private
  attr_reader :nessus_id, :xmldoc

  def nessus
    nessi = TenableRuby::Client.new(
              credentials: {
                access_key: Rails.application.secrets.nessus_access_key,
                secret_key: Rails.application.secrets.nessus_secret_key
              },
              url: Boskop.nessus_url
            )
    nessi.authenticate
    nessi
  end

  def scan
    NessusScan.where(nessus_id: nessus_id).first
  end

  def valid?
    return false if @xmldoc.blank?
    @xmldoc.xpath("//NessusClientData_v2").present?
  end

end
