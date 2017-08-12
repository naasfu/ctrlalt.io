class SessionsController < ApplicationController

  # GET /login
  def new
    # Upon successful log in, the user is redirected to the session[:return_to]
    # if set. We can manually create a log in link to redirect the user to a 
    # specific location.
    # ex: https://ctrlalt.io/login?return_to=https://google.com
    session[:return_to] = params[:return_to] if params[:return_to].present?
  end

  # POST /login
  def create
    user = User.find_by_email(params[:email].downcase)

    if user && user.authenticate(params[:password])
      # Log in user
      session[:user_id] = user.id

      # Redirect to session[:return_to] or to the home page.
      redirect_to login_redirect_url
    else
      # Invalid credentials.
      redirect_to login_url, error: t(".invalid_email")
    end
  end

  # GET /logout
  def destroy
    # Securely destroy the current session.
    reset_session

    # Go back to the home page.
    redirect_to root_url, success: t(".logged_out")
  end

private

  # Redirect to session[:return_to] or to the home page.
  def login_redirect_url
    session[:return_to] || root_url
  end

end
