class OrderMailerPreview < ActionMailer::Preview
  def payment_receipt
    OrderMailer.payment_receipt(Order.paid.first)
  end

  def shipped
    OrderMailer.shipped(Order.paid.first)
  end
end