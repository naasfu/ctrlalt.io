class Help::FaqCategoriesController < Help::HelpController
  def show
    @faq_category ||= FaqCategory.includes(:sorted_faqs).find_by(slug: params[:slug])
  end
end
