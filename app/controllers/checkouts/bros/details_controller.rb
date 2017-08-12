class Checkouts::Bros::DetailsController < Checkouts::CheckoutsController

  def update
    notes_params = params.require(:bro_order).permit(:geekhack_username, :user_notes, :donation_amount)

    notes_params.merge!({
      donation_amount: (params[:bro_order][:donation_amount].to_f < 0 ? 0 : params[:bro_order][:donation_amount].to_f)
    })

    current_bros.update_attributes(notes_params)

    head :no_content
  end

end