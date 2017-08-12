class CancelFailedPaymentJob < ActiveJob::Base
  queue_as :payments

  def perform(order)
    order.cancel! if order.payment_failed?
  end
end
