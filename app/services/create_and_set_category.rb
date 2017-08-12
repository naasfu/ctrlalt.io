class CreateAndSetCategory
  def self.call(resource, category_name)
    category_name = 'Other' if category_name.blank?
    category      = resource.class.reflect_on_association(:category).class_name.constantize.find_or_create_by(name: category_name)
    resource.category  = category
    resource.save
  end
end