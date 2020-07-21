class Admin::TasksController < Admin::ApplicationController
  private
  def get_subject
    @subject = Subject.find_by(id: params[:subject_id])
    return if @subject

    flash[:danger] = t("controller.admin.subject.general.not_found")
    redirect_to admin_subjects_path
  end

  def get_task
    @task = @subject.tasks.find_by(id: params[:id])
    return if @task

    flash[:danger] = t("controller.admin.subject.general.not_found")
    redirect_to admin_subject_tasks_url(subject_id: params[:subject_id])
  end
end
