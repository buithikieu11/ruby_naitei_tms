class CourseSubject < ApplicationRecord
  enum status: {pending: 0, started: 1, finish: 2}

  belongs_to :subject
  belongs_to :course
end
