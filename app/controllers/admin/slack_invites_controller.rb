class Admin::SlackInvitesController < Admin::AdminController
  before_action :set_invite, only: [:show, :destroy]

  def index
    @invites ||= SlackInvite.newest
    @emails  ||= @invites.pluck(:email).join(", ")
  end

  def destroy
    @invite.destroy! if @invite
    @invites ||= SlackInvite.newest
    @emails  ||= @invites.pluck(:email).join(", ")
  end


private

  def set_invite
    @invite = SlackInvite.find(params[:id])
  end

  def invite_params
    params.require(:invite).permit!
  end
end
