class Api::RecommendedUsersController < ApiController
  before_action :authenticate_token!

  def index
    @users = current_user.recommended_users
  end
end
