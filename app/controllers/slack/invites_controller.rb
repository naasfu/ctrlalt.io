class Slack::InvitesController < ApplicationController

  def new
    @invite ||= SlackInvite.new(
      email: (current_user ? current_user.email : ""), 
      username: (current_user && current_user.username.present? ? current_user.username : "")
    )
  end

  def create
    @invite = SlackInvite.new(slack_invite_params)
    @invite.save
  end

private

  def slack_invite_params
    params.require(:slack_invite).permit(:email, :username, :on_reddit, :on_geekhack)
  end

end