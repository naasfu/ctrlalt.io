class Admin::CarouselsController < Admin::AdminController
  before_action :set_carousel, only: [:edit, :update, :destroy]
  
  def index
    @carousels = Carousel.sorted
  end

  def create
    if @carousel = Carousel.create(file: params[:file])
      carousel_partial = render_to_string('admin/carousels/_carousel', layout: false, formats: [:html], locals: { carousel: @carousel })
      puts carousel_partial
      render json: { image: carousel_partial }, status: 200
    else
      render json: @carousel.errors, status: 400
    end
  end

  def edit
  end

  def update
    @carousel.update_attributes(carousel_params)
  end

  def destroy
    flash.now[:error] = "Image destroyed." if @carousel.destroy
  end

private

  def set_carousel
    @carousel = Carousel.find(params[:id])
  end

  def carousel_params
    params.require(:carousel).permit!
  end
end
