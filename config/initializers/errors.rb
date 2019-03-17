if Rails.env.production?
  Rails.application.config.middleware.use(
    ExceptionNotification::Rack,
    email: {
      email_prefix: "Boskop: ",
      sender_address: %{"notifier" <#{Boskop.mail_from}>},
      exception_recipients: %w{Wolfgang.Barth@marienhaus.de},
      sections: %w{request backtrace}
    }
  )
end
