class CourseUser < ApplicationRecord
  enum status: {pending: 0, started: 1, finish: 2}
  enum role: {trainee: 0, supervisor: 1}

  belongs_to :user
  belongs_to :course
end
