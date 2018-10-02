class ApplicationMailer < ActionMailer::Base
  default from: Boskop.mail_from
  layout 'mailer'
end

