class Api::ChatroomsController < ApiController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_token!

  def index
    @invites = current_user.chatrooms.includes(:user, :restaurant)
    invitees = @invites.map(&:invitee).uniq.compact
    @users = invitees.push(current_user)
    @users = @users.uniq.compact
    @restaurants = @invites.map(&:restaurant).uniq.compact
  end
end
