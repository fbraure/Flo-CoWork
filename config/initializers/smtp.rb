ActionMailer::Base.smtp_settings = {
  :address => 'smtp.postmarkapp.com',
  :port => 587,
  :domain => ENV['DOMAIN'] || "localhost:3000",
  :user_name => ENV['POSTMARK_USERNAME'],
  :password => ENV['POSTMARK_PASSWORD'],
  :authentication => :plain,
  :enable_starttls_auto => true
}
