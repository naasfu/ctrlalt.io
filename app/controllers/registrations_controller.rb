class RegistrationsController < ApplicationController

  layout 'containerless'

  # GET /register
  def new
    @user = User.new
  end

  # POST /register
  def create
    @user = User.new(user_params)

    if @user.save
      # Send email confirmation.
      UserMailer.email_confirmation_instructions(@user).deliver_later

      # Login by setting the user_id for current_user.
      session[:user_id] = @user.id

      # Return to checkout or homepage.
      redirect_to login_redirect_url, success: t(".welcome")
    else
      # Render the form again with errors.
      render :new
    end
  end

private
  
  # Strong params.
  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end

  # Return the user to previous location if set or to homepage.
  def login_redirect_url
    session[:return_to] || root_url
  end

end
