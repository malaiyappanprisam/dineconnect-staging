class Api::InvitesController < ApiController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_token!

  def index
    @invites = current_user.invites_by_other.includes(:user, :restaurant)
    @users = @invites.map(&:user).uniq.compact
    @restaurants = @invites.map(&:restaurant).uniq.compact
  end

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
    invite = Invite.find(params[:id])
    if invite.update(status: :accept)
      render nothing: true, status: :ok
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def reject
    invite = Invite.find(params[:id])
    if invite.update(status: :reject)
      render nothing: true, status: :ok
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def destroy
    invite = Invite.find(params[:id])
    invite.destroy
    render nothing: true, status: :ok
  end

  private
  def invite_params
    params
      .require(:invite)
      .permit(:invitee_id, :restaurant_id, :payment_preference)
      .merge(user: current_user)
  end

  def current_user
    @current_user
  end
end