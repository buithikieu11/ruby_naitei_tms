class Task < ApplicationRecord
  belongs_to :subject
  has_many :user_tasks, dependent: :destroy

  enum status: {pending: 0, started: 1, finished: 2}
  VALID_NAME_REGEX = /\A[a-zA-Z0-9 ]+\z/i.freeze

  validates :name, presence: true,
                   format: {with: VALID_NAME_REGEX}
  validates :step, presence: true,
                   numericality: {greater_than: Settings.model.task.step.greater_than}
  validates :status, presence: true,
                     numericality: true,
                     inclusion: {in: statuses.keys}
  validates :duration, presence: true,
                       numericality: {greater_than: Settings.model.task.duration.greater_than}
end
