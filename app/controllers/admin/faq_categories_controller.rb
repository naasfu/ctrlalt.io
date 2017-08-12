class Admin::FaqCategoriesController < Admin::AdminController
  before_action :set_faq_category, only: [:show, :edit, :update, :destroy]

  def index
    @faq_categories = FaqCategory.sorted
  end

  def new
    @faq_category = FaqCategory.new
  end

  def create
    @faq_category = FaqCategory.new(faq_category_params)
    if @faq_category.save
      redirect_to admin_faq_categories_path, success: "FAQ category created successfully"
    else
      render :new
    end
  end

  def show
    @faqs = @faq_category.faqs.sorted
  end

  def edit
  end

  def update
    if @faq_category.update_attributes(faq_category_params)
      redirect_to admin_faq_categories_path, success: "FAQ category created successfully"
    else
      render :edit
    end
  end

  def destroy
    flash.now[:success] = "FAQ category destroyed." if @faq_category.destroy
  end

private

  def set_faq_category
    @faq_category = FaqCategory.find_by(slug: params[:slug])
  end

  def faq_category_params
    params.require(:faq_category).permit!
  end

end
