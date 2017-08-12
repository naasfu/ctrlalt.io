module Admin::OrderSearchUrlOptionsHelper
  def order_search_url_options(options={})
    o = { 
      workflow_state: params[:workflow_state], 
      product_id:     params[:product_id], 
      variant_id:     params[:variant_id],
      location:       params[:location],
      keyword:        params[:keyword]
    }
    o.merge!(options)
  end
end
