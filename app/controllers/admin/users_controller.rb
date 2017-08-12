class Admin::UsersController < Admin::AdminController
  before_action :set_user, only: [:show, :edit, :update]

  def index
    results = User.all

    if params[:workflow_state].present?
      results = results.where(workflow_state: params[:workflow_state])
    end

    if params[:keyword].present?
      results = results.where(
        user_search_query(['username', 'headline', 'about', 'stripe_customer_id']),
        search: "%#{params[:keyword]}%"
      )
    end

    @users = results.newest.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to edit_admin_user_url(@user), success: t('.success')
    else
      render :edit
    end
  end

private
  
  def user_params
    params.require(:user).permit!
  end
  
  def set_user
    @user = User.find_by(username: params[:username])
  end

  def user_search_query(options=[])
    query = ''
    options.each do |attribute|
      query += "#{attribute} LIKE :search OR "
    end
    query[0..-4] # Remove the appended ' OR '
  end
end
