class Admin::BroProductImagesController < Admin::AdminController
  before_action :set_bro_sale
  before_action :set_product
  before_action :set_image, only: [:edit, :update, :destroy]

  def index
    @images = @product.images.sorted
  end

  def edit
  end

  def update
    if @image.update_attributes(params.require(:bro_product_image).permit!)
      redirect_to edit_admin_bro_sale_product_image_url(@bro_sale, @product, @image)
    else
      render :edit
    end
  end

  def create
    if @image = @product.images.create(file: params[:file])
      image_partial = render_to_string('admin/bro_product_images/_bro_product_image', layout: false, formats: [:html], locals: { bro_product_image: @image })
      render json: { image: image_partial }, status: 200
    else
      render json: @image.errors, status: 400
    end
  end

  def destroy
    flash.now[:success] = 'Image destroyed.' if @image.destroy
  end

private
  
  def set_product
    @product = BroProduct.find_by(slug: params[:product_slug])
  end
  
  def set_bro_sale
    @bro_sale = BroSale.find_by(slug: params[:bro_sale_slug])
  end

  def set_image
    @image = BroProductImage.find(params[:id])
  end
end
