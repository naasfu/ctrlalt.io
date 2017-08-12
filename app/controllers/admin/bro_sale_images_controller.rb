class Admin::BroSaleImagesController < Admin::AdminController
  before_action :set_bro_sale

  def index
    @images = @bro_sale.images.sorted
  end

  def create
    if @image = @bro_sale.images.create(file: params[:file])
      image_partial = render_to_string('admin/bro_sale_images/_bro_sale_image', layout: false, formats: [:html], locals: { bro_sale_image: @image })
      render json: { image: image_partial }, status: 200
    else
      render json: @image.errors, status: 400
    end
  end

  def destroy
    @image = BroSaleImage.find(params[:id])
    @image.destroy
    flash.now[:success] = 'Image destroyed.'
  end

private
  
  def set_bro_sale
    @bro_sale = BroSale.find_by(slug: params[:bro_sale_slug])
  end
end
