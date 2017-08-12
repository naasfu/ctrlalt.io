class Admin::BroOrderNotesController < ApplicationController
  before_action :set_bro_order, only: [:new, :create]

  def new
    @note = @bro_order.notes.build
  end

  # POST /admin/bro_orders/:bro_order_id/notes
  def create
    @note = @bro_order.notes.build(note_params)
    @note.user = current_user
    flash.now[:success] = 'Note created.' if @note.save
  end

  # DELETE /admin/bro_orders/:bro_order_id/notes/:id
  def destroy
    @note = BroOrderNote.find(params[:id])
    flash.now[:success] = 'Note destroyed.' if @note.destroy
  end

private

  def note_params
    params.require(:bro_order_note).permit!
  end

  def set_bro_order
    @bro_order = BroOrder.find_by(guid: params[:bro_order_guid])
  end
end
