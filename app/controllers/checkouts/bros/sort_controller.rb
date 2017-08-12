class Checkouts::Bros::SortController < Checkouts::CheckoutsController
  def sort
    params[:cart_bro_line_item].each_with_index do |id, index|
      BroLineItem.where(id: id).update_all(position: index+1)
    end
    
    render nothing: true
  end
end
