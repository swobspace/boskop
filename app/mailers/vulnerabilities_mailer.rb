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
    mail_cc = options.fetch(:mail_cc, [])
    prefix  = options.fetch(:prefix, "")
    subject = options.fetch(:subject, I18n.t('vulnerabilities_mailer.send_csv.subject', lid: @lid))

    attachments["vulnerabilities-#{@lid}-#{Date.today}.csv"] =
      {
        mime_type: 'text/csv', 
        content: vulnerabilities.to_csv(col_sep: "\t")
      }

    mail to: mail_to, cc: mail_cc, subject: "#{prefix}#{subject}"
  end

end
