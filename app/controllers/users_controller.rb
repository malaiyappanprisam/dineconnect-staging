class UsersController < ApplicationController
  before_action :require_login

  def index
    @users = User
    if params[:search].present?
      @users = @users.fuzzy_search(params[:search])
    end
    @q = @users.ransack(params[:q])
    @users = @q.result(distinct: true)
    @users = @users.order(created_at: :desc).page(params[:page])
    authorize @users
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params.merge(email_confirmed_at: Time.current))
    authorize @user
    if @user.save
      redirect_to user_path(@user), info: "Success"
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def reset_password
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update(user_params)
      redirect_to user_path(@user), info: "Success"
    else
      render :edit
    end
  end

  def activate
    @user = User.find(params[:id])
    authorize @user
    @user.update(active: true)
    redirect_to users_path, info: "User activated"
  end

  def deactivate
    @user = User.find(params[:id])
    authorize @user
    @user.update(active: false)
    redirect_to users_path, info: "User deactivated"
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user
    @user.destroy
    redirect_to users_path, info: "Success"
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :role, :first_name,
                                 :last_name, :username, :gender,
                                 :about_me, :date_of_birth, :profession,
                                 :nationality, :residence_status,
                                 :interested_to_meet, :payment_preference,
                                 :interested_in_list, :favorite_food_list,
                                 :location, :avatar)
  end
end
