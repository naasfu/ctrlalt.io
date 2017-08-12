class Account::EmailUnsubscribeController < ApplicationController

  def show
    user = User.find_by(unsubscribe_token: params[:unsubscribe_token])

    if user
      user.update_attribute(:all_newsletters, false)
      redirect_to root_url, success: "No more emails for you."
    else
      redirect_to root_url, error: "Invalid unsubscription token. Please try again or contact us."
    end
  end

end
