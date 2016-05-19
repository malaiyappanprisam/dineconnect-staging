class Api::TokensController < ApiController

  def check
    authenticate_token!
    render nothing: true, status: :ok
  end
end
