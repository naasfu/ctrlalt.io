class Admin::FaqsController < Admin::AdminController

  before_action :set_faq_category
  before_action :set_faq, only: [:edit, :update, :destroy]

  def index
    @faqs = @faq_category.faqs.sorted
  end

  def new
    @faq = @faq_category.faqs.build
  end

  def create
    @faq = @faq_category.faqs.build(faq_params)
    if @faq.save
      redirect_to admin_faq_category_faqs_url(@faq_category), success: "FAQ created successfully"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @faq.update_attributes(faq_params)
      redirect_to admin_faq_category_faqs_url(@faq_category), success: "FAQ created successfully"
    else
      render :edit
    end
  end

  def destroy
    flash.now[:success] = "FAQ destroyed." if @faq.destroy
  end

private

  def set_faq
    @faq = Faq.find_by(slug: params[:slug])
  end

  def set_faq_category
    @faq_category = FaqCategory.find_by(slug: params[:faq_category_slug])
  end

  def faq_params
    params.require(:faq).permit!
  end

end
