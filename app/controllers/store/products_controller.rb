class Store::ProductsController < Store::StoreController
  before_action :set_store_categories, only: [:index, :oos]

  # GET /store
  def index
    @products = @store.products.purchaseable.sorted
  end

  # GET /store/products/:slug
  def show
    @product = @store.products.find_by(slug: params[:slug])
    @variants = @product.variants.sorted
    @images = @product.images.sorted
    @similar_products = @store.products.where(category: @product.category).where.not(id: @product.id).purchaseable.sorted
    render layout: "containerless"
  end

private

  def set_store_categories
    @store_categories ||= ProductCategory.visible.active.sorted
  end

end
