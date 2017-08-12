class UpdateInventoryStockJob < ActiveJob::Base
  queue_as :inventory

  def perform(order)
    UpdateInventoryStock.call(order)
  end
end
