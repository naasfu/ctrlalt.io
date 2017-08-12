class Admin::GroupBuyImagesController < Admin::AdminController
  before_action :set_group_buy

  def index
    @images = @group_buy.images.sorted
  end

  def create
    if @image = @group_buy.images.create(file: params[:file])
      image_partial = render_to_string('admin/group_buy_images/_group_buy_image', layout: false, formats: [:html], locals: { group_buy_image: @image })
      render json: { image: image_partial }, status: 200
    else
      render json: @image.errors, status: 400
    end
  end

  def destroy
    @image = GroupBuyImage.find(params[:id])
    @image.destroy
    flash.now[:success] = 'Image destroyed.'
  end

private
  
  def set_group_buy
    @group_buy = GroupBuy.find_by(slug: params[:group_buy_slug])
  end
end
