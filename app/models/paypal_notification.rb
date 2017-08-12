class PaypalNotification < ActiveRecord::Base
  belongs_to :bro_order
  belongs_to :kwk_order
  serialize :params
  after_create :process_transaction
  
private

  def process_transaction
    order.process_transaction!

    if price_matches? && receiver_matches? && secret_matches? && status_matches?
      order.transaction_successful!
    else
      order.transaction_failed!
    end
  end

  def price_matches?
    params[:mc_gross].to_f.to_s == order.grand_total.to_f.to_s && params[:mc_currency] == 'USD'  ? true : false
  end

  def receiver_matches?
    params[:receiver_email] == ENV['paypal_email']  ? true : false
  end

  def secret_matches?
    params[:secret] == ENV['paypal_secret'] ? true : false
  end

  def status_matches?
    status == "Completed" ? true : false
  end

  def order
    @order ||= order || kwk_order
  end
end