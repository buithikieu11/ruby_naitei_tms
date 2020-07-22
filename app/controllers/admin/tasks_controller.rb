class Admin::TasksController < Admin::ApplicationController
  include Admin::ApplicationHelper

  before_action :get_subject
  before_action :get_task, except: [:index, :new, :create]
  before_action :extract_params, only: [:index]
  before_action :task_params, only: [:create]

  def index
    @tasks = @subject.tasks.find_by_name(@search)
                     .paginate(page: @page, per_page: @per_page)
    flash.now[:danger] = t("controller.admin.task.index.no_result") if !@search.nil? && @tasks.count == 0
  end

  def new
    @task = Task.new
  end

  def create
    params = task_params.to_h
    if(@subject.tasks.count == 0)
      params[:step] = 1
    else
      params[:step] = @subject.tasks.last.step + 1
    end
    params[:duration] = params[:duration].to_i
    @task = @subject.tasks.new(params)
    if @task.save
      flash[:success] = t("controller.admin.task.create.created_successfully",
                          subject_name: @subject.name)
      redirect_to admin_subject_tasks_path
    else
      render "new"
    end
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

  def task_params
    params.require(:task)
          .permit(:name, :description, :duration)
  end
end
