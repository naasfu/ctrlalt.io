class Admin::NotesController < ApplicationController
  before_action :set_order, only: [:new, :create]

  def new
    @note = @order.notes.build
  end

  # POST /admin/orders/:order_id/notes
  def create
    @note = @order.notes.build(note_params)
    @note.user = current_user
    flash.now[:success] = 'Note created.' if @note.save
  end

  # DELETE /admin/orders/:order_id/notes/:id
  def destroy
    @note = Note.find(params[:id])
    flash.now[:success] = 'Note destroyed.' if @note.destroy
  end

private

  def note_params
    params.require(:note).permit!
  end

  def set_order
    @order = Order.find_by(guid: params[:order_guid])
  end
end
