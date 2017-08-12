class CreateAndSetFaqCategory
  def self.call(faq, category_name)
    category_name = 'Other' if category_name.blank?
    category      = FaqCategory.find_or_create_by(name: category_name)
    faq.category  = category
    faq.save
  end
end