class TrackingNoteMailer < ApplicationMailer
  default from: "[CTRL]ALT <orders@#{ENV['app_url']}>"

  def new_tracking(tracking_note)
    @tracking_note = tracking_note
    @order = @tracking_note.order
    @shipping_address = @order.shipping_address
    @line_items = @order.line_items
    mail(to: @order.email, subject: "Shipment details for ##{@order.guid}")
  end
end
