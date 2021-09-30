class EmailInterceptor
  def self.delivering_email(message)
    message.subject = message.to + " " + message.subject
    message.to = [ ENV['DEFAULT_EMAIL_INTERCEPTOR'] ]
  end
end
