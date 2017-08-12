class Admin::MicropostsController < Admin::AdminController
  before_action :set_group_buy
  before_action :set_micropost, only: [:edit, :update, :destroy]

  def index
    @microposts = @group_buy.microposts.newest
  end

  def new
    @micropost = @group_buy.microposts.build
  end

  def create
    @micropost = @group_buy.microposts.build(micropost_params)
    @micropost.user = current_user
    if @micropost.save
      redirect_to edit_admin_group_buy_micropost_url(@group_buy, @micropost), success: "Micropost created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @micropost.update_attributes(micropost_params)
      redirect_to edit_admin_group_buy_micropost_url(@group_buy, @micropost), success: "Micropost updated."
    else
      render :edit
    end
  end

  def destroy
    flash.now[:success] = "Micropost destroyed." if @micropost.destroy
  end

private
  def set_group_buy
    @group_buy = GroupBuy.find_by(slug: params[:group_buy_slug])
  end

  def set_micropost
    @micropost = Micropost.find(params[:id])
  end

  def micropost_params
    params.require(:micropost).permit!
  end
end
