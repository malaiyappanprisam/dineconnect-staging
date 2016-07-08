class ApiController < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token, if: :json_request?

  class AuthenticationError < Exception; end

  before_action :check_api_auth_key!

  rescue_from AuthenticationError do
    head :unauthorized
  end


  protected
  def authenticate_token!
    token = request.headers["X-API-Token"]
    device_id = request.headers["X-API-Device"]
    user_token = UserToken.find_by(token: token, device_id: device_id)
    if token.present? && device_id.present? && user_token.present? && user_token.user.present?
      @current_user = user_token.user
    else
      raise AuthenticationError
    end
  end

  private
  def json_request?
    request.format.json?
  end

  def check_api_auth_key!
    unless request.headers["X-API-AUTH"] == ENV["API_AUTH_KEY"]
      head :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
