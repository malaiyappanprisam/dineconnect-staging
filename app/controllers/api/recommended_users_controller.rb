class Api::RecommendedUsersController < ApiController
  def index
    @users = User.order(id: :desc)
  end

  
end
