class Checkouts::Kwk::DetailsController < Checkouts::KwkController

  def update
    notes_params = params.require(:kwk_order).permit(:geekhack_username, :user_notes, :donation_amount)

    notes_params.merge!({
      donation_amount: (params[:kwk_order][:donation_amount].to_f < 0 ? 0 : params[:kwk_order][:donation_amount].to_f)
    })

    current_kaps.update_attributes(notes_params)

    head :no_content
  end

end