class Api::RecommendedUsersController < ApiController
  before_action :authenticate_token!

  def index
    @users = User.order(id: :desc)
  end
end
