module Authorization
  extend ActiveSupport::Concern

  included do
    before_action :authorize

    # delegate :allow?, to: :current_permission
    
    # helper_method :allow?
    helper_method :current_user
    helper_method :admin_signed_in?
  end

private
  
  # Convenience method for checking if the current user has admin access.
  def admin_signed_in?
    current_user && current_user.admin?
  end

  # Looks up the current user.
  # When a user logs in, the session[:user_id] is set.
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # Convenience method for looking up the current user session id.
  # Used for guest users.
  def session_id
    request.session_options[:id]
  end

  # Initalize the current user permissions for authorization.
  def current_permission
    @current_permission ||= Permission.permission_for(current_user, session_id)
  end

  # Override this method when authorizing a resource.
  def current_resource
    nil
  end

  # Checks if the current user is allowed to access the given controller#action and resource.
  def authorize
    if current_permission.allow?(params[:controller], params[:action], current_resource)
      # Authorized
    else
      session[:return_to] = request.original_url
      redirect_to login_url, error: (current_user ? t('authorization.error') : t('authorization.not_signed_in'))
    end
  end
end