require 'zip'

class VulnerabilitiesMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.vulnerabilities_mailer.send_csv.subject
  #
  def send_csv(options = {})
    options = options.symbolize_keys
    # -- mandantory
    vulnerabilities  = options.fetch(:vulnerabilities)
    mail_to = options.fetch(:mail_to)
    # -- optional
    @lid  = options.fetch(:lid, "")
    mail_cc = (Array(options.fetch(:mail_cc, [])) + Boskop.always_cc).compact
    prefix  = options.fetch(:prefix, "")
    subject = options.fetch(:subject, I18n.t('vulnerabilities_mailer.send_csv.subject', lid: @lid))

    filename = "vulnerabilities-#{@lid}-#{Date.today}.csv"
    temp     = zipped_vulnerabilities(vulnerabilities, filename)

    attachments["#{filename}.zip"] =
      {
        mime_type: 'application/zip',
        content: temp.read
      }

    mail to: mail_to, cc: mail_cc, subject: "#{prefix}#{subject}"
    temp.close!
  end

private
  def zipped_vulnerabilities(vulnerabilities, filename)
    t = Tempfile.new("zipped-vulnerabilities")
    Zip::OutputStream::open(t.path) do |zip|
      zip.put_next_entry(filename)
      zip << vulnerabilities.to_csv(col_sep: "\t")
      zip.close_buffer
    end
    t
  end

end
