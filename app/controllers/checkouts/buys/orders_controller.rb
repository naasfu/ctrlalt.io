class Checkouts::OrdersController < Checkouts::CheckoutsController

  def update
    current_cart.update_attribute(:rate_id, params[:rate_id])
  end

end
