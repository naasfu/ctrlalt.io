class ChargeOrderByCardJob < ActiveJob::Base
  queue_as :payments

  def perform(token, order, user, ip_address)
    ChargeOrderByCard.call(token, order, user, ip_address)
  end
end
