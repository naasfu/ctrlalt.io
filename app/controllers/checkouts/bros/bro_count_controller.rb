class Checkouts::Bros::BroCountController < Checkouts::CheckoutsController
  def update
    if params[:bro_count].present? && (params[:bro_count].to_i.abs <= 9)
      current_bros.update_attribute(:bro_count, params[:bro_count])
    end

    render nothing: true
  end
end
