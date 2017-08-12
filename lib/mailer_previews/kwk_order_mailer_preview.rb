class KwkOrderMailerPreview < ActionMailer::Preview
  def submitted
    KwkOrderMailer.submitted(KwkOrder.with_submitted_state.last)
  end

  def approved
    KwkOrderMailer.approved(KwkOrder.with_winner_state.last)
  end
end