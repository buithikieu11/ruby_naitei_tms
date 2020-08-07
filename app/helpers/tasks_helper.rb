module TasksHelper
  def full_task_url_with_params *current_params, additional_param
    subject_tasks_url(request.params.slice(*current_params).merge(additional_param))
  end
end
