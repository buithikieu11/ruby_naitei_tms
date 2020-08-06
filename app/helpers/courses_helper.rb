module CoursesHelper
  def verify_available_course(course)
    if current_user.courses.include?(course)
      t("view.course.show.joined_course_message")
    elsif !current_user.courses.include?(course) && course.started?
      t("view.course.show.contact_supervisor_message")
    elsif course.pending?
      t("view.course.show.pending_course_message")
    elsif course.finished?
      t("view.course.show.finished_course_message")
    else
      ""
    end
  end

  def full_course_url_with_params(*current_params, additional_param)
    course_url(request.params.slice(*current_params).merge(additional_param))
  end
end