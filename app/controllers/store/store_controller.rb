class Store::StoreController < ApplicationController
  before_action :set_store

private

  def set_store
    @store = GroupBuy.find_by(slug: 'store')
  end
end
