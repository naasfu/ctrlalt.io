class Admin::Kwk::KwkSalesController < Admin::AdminController
  before_action :set_kwk_sale, only: [:show, :edit, :update, :destroy]

  layout 'admin/fixed'
  
  def index
    @kwk_sales = KwkSale.by_deadline
  end

  def show
    @kwk_orders   = @kwk_sale.orders.sorted.limit(5)
    @products = @kwk_sale.products.sorted
  end

  def new
    @kwk_sale = KwkSale.new
  end

  def create
    @kwk_sale = KwkSale.new(kwk_sale_params)

    if @kwk_sale.save
      redirect_to edit_admin_kwk_sale_url(@kwk_sale), success: "Sale #{@kwk_sale.name} created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @kwk_sale.update_attributes(kwk_sale_params)
      redirect_to edit_admin_kwk_sale_url(@kwk_sale), success: "Sale #{@kwk_sale.name} updated."
    else
      render :edit
    end
  end

  def destroy
    if @kwk_sale.destroy
      flash.now[:success] =  "Sale #{@kwk_sale.name} destroyed." 
    end
  end

private

  def set_kwk_sale
    @kwk_sale = KwkSale.find_by(slug: params[:slug])
  end

  def kwk_sale_params
    params.require(:kwk_sale).permit!
  end
end
