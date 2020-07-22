class UsersController < ApplicationController

  def index; end

  def new
    @user = User.new
    render "users/new", layout: "auth"
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user
      @courses = @user.courses
      @user_course_status = @user.course_users.where(status: params[:status])
      @collection = @courses.zip(@user_course_status)
      render "users/show"
    else
      flash[:danger] = t("controller.user.show.user_not_found")
      redirect_to root_path
    end
    # @courses = @user.join(:course_users, :courses)

  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] = t("controller.user.create.create_user_success_message")
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
