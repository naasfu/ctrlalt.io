class Admin::TrackingNotesController < ApplicationController
  before_action :set_order, only: [:new, :create]

  def new
    @tracking_note = @order.tracking_notes.build
  end

  def create
    @tracking_note = @order.tracking_notes.build(tracking_note_params)
    @order.ship! if @order.paid?

    if @tracking_note.save
      TrackingNoteMailer.new_tracking(@tracking_note).deliver_later
      flash.now[:success] = 'Tracking note created.'
    end
  end

  def destroy
    @tracking_note = TrackingNote.find(params[:id])
    flash.now[:error] = 'Tracking note destroyed.' if @tracking_note.destroy
  end

private

  def tracking_note_params
    params.require(:tracking_note).permit!
  end

  def set_order
    @order = Order.find_by(guid: params[:order_guid])
  end
end
