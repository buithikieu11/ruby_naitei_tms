class UsersController < ApplicationController

  def index; end

  def new
    @user = User.new
    render "users/new", layout: "auth"
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user
      @courses = @user.courses.filter_course_by_status(params[:status])
      render "users/show"
    else
      flash[:danger] = t("controller.user.show.user_not_found")
      redirect_to root_path
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] = t("app.controller.user.create")
      redirect_to root_url
    else
      render "users/new", layout: "auth"
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :phone_number, :password, :password_confirmation)
  end
end
