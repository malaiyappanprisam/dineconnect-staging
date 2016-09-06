class Api::InvitesController < ApiController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_token!

  def index
    @invites = current_user.invites_by_other.includes(:user, :restaurant)
    users = @invites.map(&:user).uniq.compact
    @users = users.push(current_user)
    @restaurants = @invites.map(&:restaurant).uniq.compact
  end

  def create
    @invite = Invite.new(invite_params)
    if @invite.save
      @invites = [@invite].compact
      render "api/invites/invite"
    else
      render json: { errors: @invite.errors }, status: :unprocessable_entity
    end
  end

  def accept
    invite = Invite.find(params[:id])
    if invite.update(status: :accept)
      render nothing: true, status: :ok
    else
      render json: { errors: invite.errors }, status: :unprocessable_entity
    end
  end

  def reject
    invite = Invite.find(params[:id])
    if invite.update(status: :reject)
      render nothing: true, status: :ok
    else
      render json: { errors: invite.errors }, status: :unprocessable_entity
    end
  end

  def block
    invite = Invite.find(params[:id])
    if invite.status == "accept"
      invite.update(status: :block)
      render nothing: true, status: :ok
    elsif invite.status == "block"
      invite.update(status: :accept)
      render nothing: true, status: :ok
    end
  end

  def hide
    invite = Invite.find(params[:id])
    if invite.showing?
      invite.update(showing: false)
      render nothing: true, status: :ok
    else
      invite.update(showing: true)
      render nothing: true, status: :ok
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
