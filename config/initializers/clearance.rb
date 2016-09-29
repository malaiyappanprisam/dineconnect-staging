Clearance.configure do |config|
  config.mailer_sender = "no-reply@dineconnectapp.com"
  config.allow_sign_up = false
  config.routes = false
  config.sign_in_guards = [ConfirmedUserGuard]
end
