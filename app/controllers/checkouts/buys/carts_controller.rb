class Checkouts::Buys::CartsController < Checkouts::CheckoutsController

  def show
    @line_items = current_cart.line_items
  end
  
end
