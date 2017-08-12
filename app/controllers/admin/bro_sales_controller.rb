class Admin::BroSalesController < Admin::AdminController
  before_action :set_bro_sale, only: [:show, :edit, :update, :destroy]

  def index
    @bro_sales = BroSale.by_deadline
  end

  def show
    @bro_orders   = @bro_sale.orders.sorted.limit(5)
    @products = @bro_sale.products.sorted
  end

  def new
    @bro_sale = BroSale.new
  end

  def create
    @bro_sale = BroSale.new(bro_sale_params)

    if @bro_sale.save
      redirect_to edit_admin_bro_sale_url(@bro_sale), success: "Sale #{@bro_sale.name} created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @bro_sale.update_attributes(bro_sale_params)
      redirect_to edit_admin_bro_sale_url(@bro_sale), success: "Sale #{@bro_sale.name} updated."
    else
      render :edit
    end
  end

  def destroy
    if @bro_sale.destroy
      flash.now[:success] =  "Sale #{@bro_sale.name} destroyed." 
    end
  end

private

  def set_bro_sale
    @bro_sale = BroSale.find_by(slug: params[:slug])
  end

  def bro_sale_params
    params.require(:bro_sale).permit!
  end
end
