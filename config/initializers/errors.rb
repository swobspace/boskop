if Rails.env.production?
  Rails.application.config.middleware.use(
    ExceptionNotification::Rack,
    email: {
      email_prefix: "#{Beschlussdb.title_short}: ",
      sender_address: %{"notifier" <#{Beschlussdb.mail_from}>},
      exception_recipients: %w{Wolfgang.Barth@marienhaus.de},
      sections: %w{request backtrace}
    }
  )
end
