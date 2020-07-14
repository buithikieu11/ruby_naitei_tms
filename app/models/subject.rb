class Subject < ApplicationRecord
  enum status: {pending: 0, started: 1, finished: 2}

  has_many :course_subjects, dependent: :destroy
  has_many :courses, through: :course_subjects
  has_many :user_subjects, dependent: :destroy
  has_many :users, through: :user_subjects
  has_many :tasks, dependent: :destroy

  VALID_NAME_REGEX = /\A[a-zA-Z0-9 ]+\z/i.freeze

  validates :name, presence: true,
                   format: {with: VALID_NAME_REGEX}
  validates :status, presence: true,
                     numericality: true,
                     inclusion: {in: statuses.keys}
end
