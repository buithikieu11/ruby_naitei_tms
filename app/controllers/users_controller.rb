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
      @user_course_status = @user.course_users.filter_course_by_status(params[:status])
      @collection = @courses.zip(@user_course_status)
      render "users/show"
    else
      flash[:danger] = t("controller.user.show.user_not_found")
      redirect_to root_path
    end
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

  # def join_course
  #   @course_expected = Course.find_by(id: params[:id])
  #   @user = current_user
  #   @courses = @user.courses
  #   if @courses.include?(@course_expected)
  #     if @course_expected.finished?
  #       flash.now[:info] = t("controller.user.join_course.course_finish_message")
  #       redirect_to course_path(@course_expected)
  #     elsif @course_expected.pending?
  #       flash.now[:warning] = t("controller.user.join_course.course_pending_message")
  #       redirect_to course_path(@course_expected)
  #     end
  #   else
  #     @user.courses << @course_expected
  #     flash[:success] = t("controller.user.join_course.course_join_success_message")
  #     redirect_to course_path(@course_expected.id)
  #   end
  # end

  private
  def user_params
    params.require(:user).permit(:username, :email, :phone_number, :password, :password_confirmation)
  end
end
