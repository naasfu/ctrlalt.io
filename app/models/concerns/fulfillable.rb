module Fulfillable
  extend ActiveSupport::Concern
  
  included do
    scope :newest,        -> { order(created_at: :desc) }
    scope :not_preparing, -> { where.not(workflow_state: 'preparing') }
    scope :sorted,        -> { where.not(workflow_state: ['preparing', 'refunded']).newest }

    workflow do
      state :preparing do
        event :ship, transition_to: :shipping
        event :cancel, transition_to: :canceled
      end
      state :shipping do
        event :refund, transition_to: :refunded
      end
      state :refunded
    end
  end
end