class OrderMailer < ApplicationMailer
  default from: "[CTRL]ALT <orders@ctrlalt.io>"

  def payment_receipt(order)
    @order = order
    @shipping_address = @order.shipping_address
    @line_items       = @order.line_items
    mail(to: @order.email, subject: "##{@order.guid} Payment receipt")
  end

  def shipped(order)
    @order = order
    @shipping_address = @order.shipping_address
    @line_items       = @order.line_items
    mail(to: @order.email, subject: "##{@order.guid} is on the way!")
  end
end