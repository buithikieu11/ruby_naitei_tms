module Admin::SubjectsHelper
  def full_url_with_params *current_params, additional_param
    admin_subjects_url(request.params.slice(*current_params).merge(additional_param))
  end
end
