class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Authorization concern.
  include Authorization

  # Configure additonal flash message types.
  add_flash_types :success, :error

  # Current group buy and store cart.
  helper_method :current_cart
  helper_method :current_buys
  helper_method :current_buys?
  
  # Current Bro Caps cart.
  helper_method :current_bros

  # Active Bro Cap sales.
  helper_method :current_bro_sales
  helper_method :current_bro_sales?

  # Current KWK cart.
  helper_method :current_kaps

  # Active KWK sales.
  helper_method :current_kwk_sales
  helper_method :current_kwk_sales?

private
  
  # Current Bro Cap sales.
  def current_buys
    @current_buys ||= GroupBuy.ongoing
  end

  # Check if there are any Bro Cap sales.
  def current_buys?
    current_buys.any?
  end
  
  # Current Bro Cap sales.
  def current_bro_sales
    @current_bro_sales ||= BroSale.ongoing
  end

  # Check if there are any Bro Cap sales.
  def current_bro_sales?
    current_bro_sales.any?
  end
  
  # Current KWK sales.
  def current_kwk_sales
    @current_kwk_sales ||= KwkSale.ongoing
  end

  # Check if there are any KWK sales.
  def current_kwk_sales?
    current_kwk_sales.any?
  end

  # Find or crate group buy/store cart for current session.
  def current_cart
    @current_cart = Order.carts.includes(:line_items).find_or_create_by(session_id: session_id)
  end

  # Find or crate bro cart for current session.
  def current_bros
    @current_bros = BroOrder.carts.includes(:line_items).find_or_create_by(session_id: session_id)
  end

  # Find or crate KWK cart for current session.
  def current_kaps
    @current_kaps = KwkOrder.carts.includes(:line_items).find_or_create_by(session_id: session_id)
  end
end
