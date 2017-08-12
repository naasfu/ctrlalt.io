class Account::ProfilesController < ApplicationController
  # GET /account/info
  def edit
    @user = current_user
  end

  # PATCH /account/info
  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to account_info_url, success: "Updated profile."
    else
      render :edit
    end
  end

private
  
  def user_params
    params.require(:user).permit(:email, :username, :avatar, :avatar_cache, 
                                 :remove_avatar, :slug, :headline, :password, 
                                 :password_confirmation, :all_newsletters, :signature)
  end
end
