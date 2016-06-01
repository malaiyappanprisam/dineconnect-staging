class Api::InvitesController < ApiController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_token!

  def create
    invite = Invite.new(invite_params)
    if invite.save
      render(json: { channel_group: invite.user.reload.channel_group },
             status: :ok)
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def accept
    invite = Invite.find_by!(accept_reject_params)
    if invite.update(status: :accept)
      render nothing: true, status: :ok
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def reject
    invite = Invite.find_by!(accept_reject_params)
    if invite.update(status: :reject)
      render nothing: true, status: :ok
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  private
  def invite_params
    params.require(:invite).permit(:invitee_id).merge(user: current_user)
  end

  def accept_reject_params
    params.require(:invite).permit(:user_id).merge(invitee: current_user)
  end

  def current_user
    @current_user
  end
end
