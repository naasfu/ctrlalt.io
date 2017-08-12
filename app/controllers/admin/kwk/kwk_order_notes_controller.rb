class Admin::Kwk::KwkOrderNotesController < ApplicationController
  before_action :set_order, only: [:new, :create]

  def new
    @note = @order.notes.build
  end

  def create
    @note = @order.notes.build(note_params)
    @note.user = current_user
    flash.now[:success] = 'Note created.' if @note.save
  end

  def destroy
    @note = KwkOrderNote.find(params[:id])
    flash.now[:success] = 'Note destroyed.' if @note.destroy
  end

private

  def note_params
    params.require(:kwk_order_note).permit!
  end

  def set_order
    @order = KwkOrder.find_by(guid: params[:order_guid])
  end
end
