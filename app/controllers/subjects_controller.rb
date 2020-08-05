class SubjectsController < ApplicationController
  include SessionsHelper

  before_action :get_subject, only: [:show]
  before_action :check_permission, only: [:show]

  def show
    user_tasks = UserTask.where_in(:task_id, @subject.tasks.pluck(:id))
                         .find_all_by_column(:user_id, current_user.id)
    if user_tasks
      @task_progress = ((user_tasks.find_all_by_column(:progress, 100).count /
                        Float(@subject.tasks.count)) * 100).round
    else
      @task_progress = 0
    end
  end

  private
  def get_subject
    @subject = Subject.find_by(id: params[:id])
    return if @subject

    flash[:danger] = t("controller.admin.subject.general.not_found")
    redirect_to admin_subjects_path
  end

  def check_permission
    user_courses = current_user.courses.started
    permission = false
    user_courses.each do |course|
      if course.subjects.include?(@subject)
        permission = true
        break
      end
    end
    unless permission
      flash[:danger] = t("controller.subject.show.do_not_have_permission")
      redirect_to root_path
    end
  end
end
