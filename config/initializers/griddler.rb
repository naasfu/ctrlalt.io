Griddler.configure do |config|
  config.processor_class = EmailProcessor # CommentViaEmail
  config.processor_method = :process
  config.email_service = :sendgrid
  config.reply_delimiter = "# Please type your reply above this line #"
end