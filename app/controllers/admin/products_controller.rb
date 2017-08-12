class Admin::ProductsController < Admin::AdminController
  before_action :set_group_buy
  before_action :set_product, only: [:edit, :update, :destroy]

  def index
    @products = @group_buy.products.sorted
  end

  def new
    @product = @group_buy.products.build
  end

  def create
    @product = @group_buy.products.build(product_params)

    if @product.save
      create_and_set_category
      redirect_to edit_admin_group_buy_product_url(@group_buy, @product), success: "Product #{@product.name} created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update_attributes(product_params)
      create_and_set_category
      redirect_to edit_admin_group_buy_product_url(@group_buy, @product), success: "Product #{@product.name} updated."
    else
      render :edit
    end
  end

  def destroy
    flash.now[:success] = "Product #{@product.name} destroyed." if @product.destroy
  end

private

  def create_and_set_category
    CreateAndSetCategory.call(@product, params[:category_name]) if params[:category_name].present?
  end

  def set_group_buy
    @group_buy = GroupBuy.find_by(slug: params[:group_buy_slug])
  end

  def set_product
    @product = Product.find_by(slug: params[:slug])
  end

  def product_params
    params.require(:product).permit!
  end
end
