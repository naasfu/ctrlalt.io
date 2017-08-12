class Admin::VariantsController < Admin::AdminController
  before_action :set_group_buy
  before_action :set_product
  before_action :set_variant, only: [:edit, :update, :destroy]

  def index
    @variants = @product.variants.sorted
  end

  def new
    @variant = @product.variants.build
  end

  def create
    @variant = @product.variants.build(variant_params)

    if @variant.save
      redirect_to edit_admin_group_buy_product_variant_url(@group_buy, @product, @variant),
        success: "Variant has been #{@variant.name} created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @variant.update_attributes(variant_params)
      redirect_to edit_admin_group_buy_product_variant_url(@group_buy, @product, @variant),
        success: "Variant has been #{@variant.name} updated."
    else
      render :edit
    end
  end

  def destroy
    flash.now[:success] = "Variant has been #{@variant.name} destroyed." if @variant.destroy
  end

private

  def set_group_buy
    @group_buy = GroupBuy.find_by(slug: params[:group_buy_slug])
  end

  def set_product
    @product = Product.find_by(slug: params[:product_slug])
  end

  def set_variant
    @variant = Variant.find(params[:id])
  end

  def variant_params
    params.require(:variant).permit!
  end
end
