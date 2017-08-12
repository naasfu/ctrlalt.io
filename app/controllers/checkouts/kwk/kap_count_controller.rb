class Checkouts::Kwk::KapCountController < Checkouts::KwkController
  def update
    kap_count = params[:kap_count].to_i.abs
    
    if params[:kap_count].present? && (kap_count <= 9)
      current_kaps.update_attribute(:kap_count, kap_count)
    end

    render nothing: true
  end
end
