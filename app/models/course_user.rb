class CourseUser < ApplicationRecord
  enum status: {pending: 0, started: 1, finished: 2}
  enum role: {trainee: 0, supervisor: 1}

  belongs_to :user
  belongs_to :course

  scope :filter_course_by_status, ->(status){where status: status if status.present? && status != "all"}

end
