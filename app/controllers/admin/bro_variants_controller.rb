class Admin::BroVariantsController < Admin::AdminController
  before_action :set_bro_sale
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
      redirect_to edit_admin_bro_sale_product_variant_url(@bro_sale, @product, @variant),
        success: "Variant has been #{@variant.name} created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @variant.update_attributes(variant_params)
      redirect_to edit_admin_bro_sale_product_variant_url(@bro_sale, @product, @variant),
        success: "Variant has been #{@variant.name} updated."
    else
      render :edit
    end
  end

  def destroy
    flash.now[:success] = "Variant has been #{@variant.name} destroyed." if @variant.destroy
  end

private

  def set_bro_sale
    @bro_sale = BroSale.find_by(slug: params[:bro_sale_slug])
  end

  def set_product
    @product = BroProduct.find_by(slug: params[:product_slug])
  end

  def set_variant
    @variant = BroVariant.find(params[:id])
  end

  def variant_params
    params.require(:bro_variant).permit!
  end
end
