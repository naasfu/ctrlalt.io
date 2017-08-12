class Help::FaqsController < Help::HelpController
  before_action :set_faq, only: [:show]

  # GET /help/faqs
  def index
    @faq_categories ||= FaqCategory.includes(:sorted_faqs).visible.active.sorted
  end

  # GET /help/faqs/:id
  def show
    @faq_category ||= @faq.category
    @similar_faqs ||= @faq.category.faqs.where.not(id: @faq.id).visible.active.sorted
  end

private
  
  def set_faq
    @faq = Faq.find_by(slug: params[:slug])
  end
end
