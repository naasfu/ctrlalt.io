class Admin::Kwk::KwkProductsController < Admin::AdminController
  before_action :set_kwk_sale
  before_action :set_product, only: [:edit, :update, :destroy]

  layout 'admin/fixed'

  def index
    @products = @kwk_sale.products.sorted
  end

  def new
    @product = @kwk_sale.products.build
  end

  def create
    @product = @kwk_sale.products.build(product_params)

    if @product.save
      redirect_to edit_admin_kwk_sale_product_url(@kwk_sale, @product), success: "Product #{@product.name} created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update_attributes(product_params)
      redirect_to edit_admin_kwk_sale_product_url(@kwk_sale, @product), success: "Product #{@product.name} updated."
    else
      render :edit
    end
  end

  def destroy
    flash.now[:success] = "Product #{@product.name} destroyed." if @product.destroy
  end

private
  def set_kwk_sale
    @kwk_sale = KwkSale.find_by(slug: params[:sale_slug])
  end

  def set_product
    @product = KwkProduct.find_by(slug: params[:slug])
  end

  def product_params
    params.require(:kwk_product).permit!
  end
end
