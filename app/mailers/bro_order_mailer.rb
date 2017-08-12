class BroOrderMailer < ApplicationMailer

  default from: "Bro Caps - [CTRL]ALT <brocaps@#{ENV['app_url']}>"

  def submitted(bro_order)
    @bro_order = bro_order
    @shipping_address = @bro_order.shipping_address
    @line_items       = @bro_order.line_items.sorted
    mail(to: @bro_order.email, subject: "##{@bro_order.guid} Ticket Confirmation")
  end

  def approved(bro_order)
    @bro_order = bro_order
    @shipping_address = @bro_order.shipping_address
    @line_items       = @bro_order.line_items.approved.sorted
    mail(to: @bro_order.email, subject: "You've won #{pluralize @line_items.size, 'bro'}!")
  end
end