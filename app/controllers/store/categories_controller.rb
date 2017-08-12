class Store::CategoriesController < Store::StoreController
  def show
    @category = ProductCategory.find_by(slug: params[:slug])
    @store_categories = ProductCategory.visible.active.sorted
    @products = @category.products.visible.active.sorted
  end
end
