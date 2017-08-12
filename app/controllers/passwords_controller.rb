class PasswordsController < ApplicationController

  # Setup @user.
  before_action :set_user, only: [:edit, :update]

  # GET /passwords/new
  def new
  end

  # POST /passwords
  def create
    # Email addresses are downcased by a before_save filter on the `User` model.
    # `find_by` is case sensitive.
    user = User.find_by(email: params[:email].downcase)

    if params[:email].blank?
      # No email is present.
      redirect_to new_password_url, error: t('.email_not_present')
    elsif user
      # Account exists.
      # Create token and set reset time.
      user.update_attributes(password_reset_token: SecureRandom.uuid(), password_reset_sent_at: Time.zone.now)

      # Send email with password reset link.
      UserMailer.password_reset_instructions(user).deliver_later

      # Go back to the home page.
      redirect_to root_url, success: t('.instructions_sent')
    else
      # Account not registered.
      redirect_to new_password_url, error: t('.account_not_found')
    end
  end

  # GET /passwords/:password_reset_token/edit
  def edit
  end

  # PATCH /passwords/:password_reset_token
  def update
    if @user.password_reset_sent_at < 2.hours.ago
      # Expire tokens older than 2 hours and force a new password reset.
      redirect_to new_password_url, error: t('.token_expired')
    elsif @user.update_attributes(password_params)
      # Reset successful.
      # Expire current token.
      @user.update_attribute(:password_reset_sent_at, 2.hours.ago)

      # Log user back in.
      session[:user_id] = @user.id

      # Go back to the home page.
      redirect_to root_url, success: t('.password_reset')
    else
      # Render the form again with errors.
      render :edit
    end
  end

private
  
  # Strong params.
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Setup @user.
  def set_user
    # Lookup user by reset token.
    @user = User.find_by(password_reset_token: params[:password_reset_token])
  end

end