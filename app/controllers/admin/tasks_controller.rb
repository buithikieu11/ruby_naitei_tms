class Admin::TasksController < Admin::ApplicationController
  include Admin::ApplicationHelper

  before_action :get_subject
  before_action :get_task, except: [:index]
  before_action :extract_params, only: [:index]

  def index
    @tasks = @subject.tasks.find_by_name(@search)
                     .paginate(page: @page, per_page: @per_page)
    flash.now[:danger] = t("controller.admin.task.index.no_result") if !@search.nil? && @tasks.count == 0
  end

  def destroy
    if @task.destroy
      flash[:success] = t("controller.admin.task.destroy.deleted")
    else
      flash[:danger] = t("controller.admin.task.destroy.failed")
    end
    redirect_to admin_subject_tasks_path
  end

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

    flash[:danger] = t("controller.admin.task.general.not_found")
    redirect_to admin_subject_tasks_url(subject_id: params[:subject_id])
  end

  def extract_params
    @page = get_number_value_from_param(params[:page], Settings.controller.admin.task.default_page)
    @per_page = get_number_value_from_param(params[:per_page], Settings.controller.admin.task.default_per_page)
    @search = get_string_value_from_param(params[:search])
  end
end
