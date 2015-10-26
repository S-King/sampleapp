class ApplicationMailer < ActionMailer::Base
# Default application mailer
  
  default from: "noreply@example.com" # Default sender address
  layout 'mailer' # Layout corresponging to email app/views/layouts
end
