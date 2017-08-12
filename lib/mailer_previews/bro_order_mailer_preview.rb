class BroOrderMailerPreview < ActionMailer::Preview
  def submitted
    BroOrderMailer.submitted(BroOrder.with_submitted_state.first)
  end

  def approved
    BroOrderMailer.approved(BroOrder.with_winner_state.first)
  end
end