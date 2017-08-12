class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    to_email = @email.to.find{ |email| email[:host] == 'feedback-ctrlalt.io' }

    if to_email
      guid = to_email[:token].split("+")[1]
    
      request = SupportRequest.find_by(guid: guid)

      if request
        comment = request.comments.create(user: request.user, content: @email.body, replied_by_email: true)
      end

    end
  end
end