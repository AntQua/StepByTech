ActionMailer::Base.smtp_settings = {
  :user_name =>"apikey", # This is the string literal ‘apikey’, NOT the ID of your API key
  :password => ENV["SENDGRID_APIKEY"], # This is the secret sendgrid API key which was issued during API key creation
  :domain => "2careproject@gmail.com",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
