class Account::EmailConfirmationsController < Account::AccountsController
  def show
    user = User.find_by(confirmation_token: params[:confirmation_token])
    if user && user.confirmed?
      redirect_to root_url, error: 'Your email has already been confirmed.'
    elsif user
      user.update_attribute(:confirmed, true)
      UserMailer.welcome(user).deliver_later
      redirect_to root_url, success: 'Your email has been confirmed.'
    else
      redirect_to root_url, error: 'Could not confirm email.'
    end
  end
end
