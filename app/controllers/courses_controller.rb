class CoursesController < ApplicationController

  before_action :get_course, :get_creator, only: [:show]

  def show
    @students = @course.users.filter_by_role(params[:role_filter])
    @subjects = @course.subjects.paginate(page: params[:page], per_page: 5)
    render "courses/show"
  end

  private
  def get_course
    @course = Course.find_by(id: params[:id])
    return if @course

    flash[:danger] = t("controller.course.show.invalid_course_message")
    redirect_to root_path
  end

  def get_creator
    @creator = User.find_by(id: @course.creator_id)
    return if @creator

    flash[:danger] = t("controller.course.show.bad_request_message")
    redirect_to root_path
  end
end