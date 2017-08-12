class KwkOrderMailer < ApplicationMailer

  default from: "Kult Worship Kaps - [CTRL]ALT <kultworshipkaps@#{ENV['app_url']}>"

  def submitted(order)
    @order = order
    @shipping_address = @order.shipping_address
    @line_items       = @order.line_items.sorted
    mail(to: @order.email, subject: "##{@order.guid} Ticket Confirmation")
  end

  def approved(order)
    @order = order
    @shipping_address = @order.shipping_address
    @line_items       = @order.line_items.approved.sorted
    mail(to: @order.email, subject: "You've won #{pluralize @line_items.size, 'kap'}!")
  end
end