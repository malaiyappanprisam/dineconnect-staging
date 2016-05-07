class ApiController < ActionController::Base
  before_action :check_api_auth_key!

  private
  def check_api_auth_key!
    unless request.headers["X-API-AUTH"] == ENV["API_AUTH_KEY"]
      render(json: { error: "Unauthorized" }, status: :unauthorized) and return
    end
  end
end
