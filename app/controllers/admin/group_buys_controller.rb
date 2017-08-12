class Admin::GroupBuysController < Admin::AdminController
  before_action :set_group_buy, only: [:show, :edit, :update, :destroy]

  def index
    @group_buys = GroupBuy.by_deadline.where.not(slug: 'store')
  end

  def show
    @orders   = @group_buy.orders.sorted.limit(5)
    @products = @group_buy.products.sorted
  end

  def new
    @group_buy = GroupBuy.new
  end

  def create
    @group_buy = GroupBuy.new(group_buy_params)

    if @group_buy.save
      redirect_to edit_admin_group_buy_url(@group_buy), success: "Group buy #{@group_buy.name} created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @group_buy.update_attributes(group_buy_params)
      redirect_to edit_admin_group_buy_url(@group_buy), success: "Group buy #{@group_buy.name} updated."
    else
      render :edit
    end
  end

  def destroy
    if @group_buy.destroy
      flash.now[:success] =  "Group buy #{@group_buy.name} destroyed." 
    end
  end

private

  def set_group_buy
    @group_buy = GroupBuy.find_by(slug: params[:slug])
  end

  def group_buy_params
    params.require(:group_buy).permit!
  end
end
