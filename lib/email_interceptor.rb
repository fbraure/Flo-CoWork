class EmailInterceptor
  def self.delivering_email(message)
    message.subject = message.to.to_s + " " + message.subject
    message.to = [ ENV['DEFAULT_EMAIL_INTERCEPTOR'] ]
  end
end
