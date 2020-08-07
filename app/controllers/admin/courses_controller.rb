class Admin::CoursesController < Admin::ApplicationController
  include Admin::CoursesHelper
  before_action :set_course, except: [:index, :create, :new]
  before_action :extract_params, only: [:index]
  before_action :check_permission, only: [:destroy, :edit, :update]
  before_action :load_subjects, only: [:new, :create]
  def new
    @course = Course.new
    @subjects
  end

  def create
    params = course_params.except(:subject_ids)
    params[:status] = params[:status].to_i
    params[:creator_id] = current_user.id

    begin
      ActiveRecord::Base.transaction do
        @course = Course.new(params)
        @course.save!
        CourseUser.create(course_id: @course.id, user_id: current_user.id, role: User.roles[:supervisor]) # save table course_user
        @course.subjects << Subject.where(id: course_params[:subject_ids].map(&:to_i)) if course_params[:subject_ids]
        flash[:success] = t("controller.admin.course.create.create_success")
        redirect_to admin_courses_path
      end
      rescue ActiveRecord::RecordInvalid 
      flash[:warning] = t("controller.admin.course.create.create_fail")
      @subjects
      render "new"
      puts t("controller.admin.course.create.transaction_fail")
    end
  end
 
  def show; end

  def edit; end
  
  def index
    @course_ids = current_user.course_users.supervisor.pluck :course_id
    @courses = Course.by_ids(@course_ids).sort_by_created_at
    if params[:search].present?
      @parameter = params[:search].downcase
      @courses = @courses.search_by_name(@parameter)
      if @courses.none? then flash.now[:warning] = t("controller.admin.course.index.course_not_found")
      end
    elsif params[:state].present?
      @courses = @courses.by_status(params[:state])
      if @courses.none? then flash.now[:warning] = t("controller.admin.course.index.course_not_found")
      end
    else
      @courses
    end
    @courses = @courses.paginate(page: @page, per_page: @per_page)
  end
  
  def update
    #course is pending
    if @course.pending?
      if edit_params[:status] == "finished"
        flash[:danger] = t("controller.admin.course.update.start_before_finish")
        update_course(except_status_params)
      else 
        update_course(edit_params)
      end 
    #course is started
    elsif @course.started?
      if edit_params[:status] == "pending"
        update_course(edit_params) unless check_course_user_started
      else 
        update_course(edit_params)
      end  
    #course is finished  
    else 
      if edit_params[:status] == "finished"
        update_course(edit_params)
      else
        update_course(edit_params) unless check_course_user_started
      end  
    end 
  end

  def destroy
    if @course.destroy
      flash.now[:success] = t("controller.admin.course.destroy.delete_success")
      respond_to do |format|
      format.json{head :no_content}
      format.js{}
    end
    else flash.now[:warning] = t("controller.admin.course.destroy.delete_fail")
         redirect_to admin_courses_path
   end  
  end

  private

  def set_course
    @course = Course.find_by(id: params[:id])
    return if @course.present?
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

  def course_params
    params.require(:course).permit(:name, :description, :status, :day_start, :day_end, subject_ids: [])
  end

  def load_subjects
    @subjects = Subject.sort_by_name
  end

  def edit_params
    params.require(:course).permit(:name, :description, :status, :day_start, :day_end )
  end
  
  def except_status_params
    params.require(:course).permit(:name, :description, :day_start, :day_end )
  end  

  def check_course_user_started
      course_user = @course.course_users.started
      return unless course_user.any?
      flash[:danger] = t("controller.admin.course.update.user_has_started")
      update_course(except_status_params)
  end  

  def update_course new_params
    if @course.update new_params
      flash[:success] = t("controller.admin.course.update.update_success")
      redirect_to admin_course_path
    else 
      flash[:danger] = t("controller.admin.course.update.update_fail")
      redirect_to edit_admin_course_path
    end  
  end  
  
end
