class Admin::BroProductsController < Admin::AdminController
  before_action :set_bro_sale
  before_action :set_product, only: [:edit, :update, :destroy]

  def index
    @products = @bro_sale.products.sorted
  end

  def new
    @product = @bro_sale.products.build
  end

  def create
    @product = @bro_sale.products.build(product_params)

    if @product.save
      redirect_to edit_admin_bro_sale_product_url(@bro_sale, @product), success: "Product #{@product.name} created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update_attributes(product_params)
      redirect_to edit_admin_bro_sale_product_url(@bro_sale, @product), success: "Product #{@product.name} updated."
    else
      render :edit
    end
  end

  def destroy
    flash.now[:success] = "Product #{@product.name} destroyed." if @product.destroy
  end

private
  def set_bro_sale
    @bro_sale = BroSale.find_by(slug: params[:bro_sale_slug])
  end

  def set_product
    @product = BroProduct.find_by(slug: params[:slug])
  end

  def product_params
    params.require(:bro_product).permit!
  end
end
