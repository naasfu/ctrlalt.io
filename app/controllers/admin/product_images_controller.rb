class Admin::ProductImagesController < Admin::AdminController
  before_action :set_group_buy
  before_action :set_product

  def index
    @images = @product.images.sorted
  end

  def create
    if @image = @product.images.create(file: params[:file])
      image_partial = render_to_string('admin/product_images/_product_image', layout: false, formats: [:html], locals: { product_image: @image })
      render json: { image: image_partial }, status: 200
    else
      render json: @image.errors, status: 400
    end
  end

  def destroy
    @image = ProductImage.find(params[:id])
    flash.now[:success] = 'Image destroyed.' if @image.destroy
  end

private
  
  def set_product
    @product = Product.find_by(slug: params[:product_slug])
  end
  
  def set_group_buy
    @group_buy = GroupBuy.find_by(slug: params[:group_buy_slug])
  end
end
