class TasksController < ApplicationController
  include ApplicationHelper
  include SessionsHelper

  before_action :get_subject
  before_action :extract_params, only: [:index]

  def index
    @tasks = @subject.tasks.find_by_name(@search)
                     .order("#{@order_by_column} #{@order_by_order}")
                     .paginate(page: @page, per_page: @per_page)
    task_ids = @tasks.pluck(:id)
    @statuses = task_ids.map{|id| [id, t("controller.task.index.in_progress")]}.to_h
    user_tasks = current_user.user_tasks.where_in(:task_id, task_ids)
    user_tasks.each do |u_t|
      @statuses[u_t.task.id] = t("controller.task.index.finished") if @tasks.include?(u_t.task) && u_t.progress == 100
    end
  end

  private
  def get_subject
    @subject = Subject.find_by(id: params[:subject_id])
    return if @subject

    flash[:danger] = t("controller.task.general.not_found")
    redirect_to root_path
  end

  def extract_params
    @page = get_number_value_from_param(params[:page],
                                        Settings.controller.task.default_page)
    @per_page = get_number_value_from_param(params[:per_page],
                                            Settings.controller.task.default_per_page)
    @search = get_string_value_from_param(params[:search])
    @order_by_column = sort_by_column(params[:order_by],
                                      Task.attribute_names,
                                      Settings.controller.task.default_sort_by_column)
    @order_by_order = sort_by_order(params[:order],
                                    Settings.controller.task.default_sort_by_order)
  end
end
