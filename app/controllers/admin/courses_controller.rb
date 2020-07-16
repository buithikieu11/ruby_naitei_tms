class Admin::CoursesController < Admin::ApplicationController
  include Admin::CoursesHelper

  before_action :set_course, except: [:index,:create,:new]
  before_action :extract_params, only: [:index]
  before_action :check_permission, only: [:destroy]

  def index
    @course_ids = current_user.course_users.supervisor.pluck :course_id
    @courses = Course.by_ids(@course_ids).sort_by_created_at()
    if params[:search].present?
      @parameter = params[:search].downcase
      @courses = @courses.search_by_name(@parameter)
      if !@courses.any? then flash.now[:warning] = t("controller.admin.course.index.course_not_found")
      end  
    elsif params[:state].present?
      @courses = @courses.by_status(params[:state])
      if !@courses.any? then flash.now[:warning] = t("controller.admin.course.index.course_not_found")
      end
    else
      @courses
    end
    @course = @course.paginate(page: @page, per_page: @per_page)

  end

  def destroy
    @course.destroy
    if @course.destroyed? then flash.now[:success] = t("controller.admin.course.destroy.delete_success")
    else flash.now[:warning] = t("controller.admin.course.destroy.delete_fail")
    end  
    respond_to do |format|
      format.json{head :no_content}
      format.js{}
    end
  end

  private

  def set_course
    @course = Course.find_by(id: params[:id])
    return if @course
    flash[:danger] = t("controller.admin.course.index.course_not_found")
    redirect_to admin_courses_path
  end

  def extract_params
    @page = params[:page].presence || Settings.controller.admin.course.default_page
    @per_page = params[:per_page].presence || Settings.controller.admin.course.default_per_page
  end

  def check_permission
    @course = Course.find_by(id: params[:id])
    return if check_owner(@course)
    flash[:danger] = t("controller.admin.course.destroy.delete_failed")
    redirect_to admin_courses_path
  end
end
