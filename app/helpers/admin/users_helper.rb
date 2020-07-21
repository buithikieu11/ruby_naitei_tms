module Admin::UsersHelper
  def full_admin_users_url_with_params(*current_params, additional_param)
    admin_users_url(request.params.slice(*current_params).merge(additional_param))
  end

  def full_user_url_with_params(*current_params, additional_param)
    user_url(request.params.slice(*current_params).merge(additional_param))
  end
end