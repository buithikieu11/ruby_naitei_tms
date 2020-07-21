module Admin::CoursesHelper

  def full_admin_courses_url_with_params(*current_params, additional_param)
    admin_courses_url(request.params.slice(*current_params).merge(additional_param))
  end

  def check_owner(course)
    current_user.id == course.creator_id
   end
end