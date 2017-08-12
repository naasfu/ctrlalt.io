class Checkouts::Kwk::SortController < Checkouts::KwkController
  def sort
    params[:cart_kwk_line_item].each_with_index do |id, index|
      KwkLineItem.where(id: id).update_all(position: index+1)
    end
    
    render nothing: true
  end
end
