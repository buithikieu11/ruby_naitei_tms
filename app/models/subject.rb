class Subject < ApplicationRecord
  enum status: {pending: 0, started: 1, finished: 2}

  has_many :course_subjects, dependent: :destroy
  has_many :courses, through: :course_subjects
  has_many :user_subjects, dependent: :destroy
  has_many :users, through: :user_subjects
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :status, presence: true,
                     numericality: true,
                     inclusion: {in: statuses.keys}

  scope :find_by_name, ->(name){where("name LIKE ?", "%#{name}%")}
end
