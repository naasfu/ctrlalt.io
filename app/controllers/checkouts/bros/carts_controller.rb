 class Checkouts::Bros::CartsController < Checkouts::CheckoutsController
  def show
    @order = current_cart
    @group_buys = GroupBuy.active.visible.by_deadline
  end
end
