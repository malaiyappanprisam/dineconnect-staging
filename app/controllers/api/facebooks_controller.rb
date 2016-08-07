class Api::FacebooksController < ApiController
  def auth
    graph = Koala::Facebook::API.new(params[:access_token])
    facebook_user = graph.get_object("me", fields: "id,name,email,gender")
    email = facebook_user["email"] || params[:email]

    return render nothing: true, status: :unauthorized unless facebook_user.present?
    return render nothing: true, status: :unauthorized unless email.present?

    @user = User.general.where("email = ? OR uid = ?", params["email"], facebook_user["id"]).first

    if @user.present?
      @user.update(uid: facebook_user["id"])
      @token = @user.access_token(params[:device_id])
      @token = @user.generate_access_token(params[:device_id]) unless @token
      @user.save!

      render template: "api/sessions/user"
    else
      @user = User.create_from_fb_response(facebook_user, email)
      if @user.valid?
        @token = @user.access_token(params[:device_id])
        @token = @user.generate_access_token(params[:device_id]) unless @token
        @user.save!
        render template: "api/sessions/user"
      else
        render json: @user.errors.to_json, status: :unprocessable_entity
      end
    end
  end
end
