class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
  
  default from: "[CTRL]ALT <info@ctrlalt.io>"
  
  # Access helpers in views
  add_template_helper(EmailHelper)

  # Access helpers in mailers
  include ActionView::Helpers::TextHelper
end