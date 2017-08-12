class Checkouts::Buys::NotesController < Checkouts::CheckoutsController

  def update
    notes_params = params.require(:order).permit(:geekhack_username, :user_notes, :donation_amount)
    current_cart.update_attributes(notes_params)
    head :no_content
  end

end