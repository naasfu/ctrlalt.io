module StripeHandler
  class Charge
    def self.succeeded(order, charge_id)
      order.update_attribute(:charge_id, charge_id)
      order.transaction_successful! if order.processing_transaction?
    end

    def self.failed(order)
      # Roll it back to unpaid so the user can try again.
      order.transaction_failed! if order.processing_transaction?
    end

    def self.captured(order)
    end

    def self.refunded(order)
    end
  end
end