class Api::ChatroomsController < ApiController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_token!

  def index
    @invites = current_user.chatrooms.includes(:user, :restaurant)
    users = @invites.map(&:user).uniq.compact
    @users = users.push(current_user)
    @restaurants = @invites.map(&:restaurant).uniq.compact
  end
end
