class EmailConfirmationsController < ApplicationController
  def update
    user = User.find_by!(email_confirmation_token: params[:token])
    user.confirm_email
    redirect_to root_path, notice: "Successfully confirming your email"
  end
end
