 class Checkouts::Kwk::CartsController < Checkouts::KwkController
  def show
    @order      ||= current_kaps
    @line_items ||= current_kaps.line_items.sorted
  end
end
