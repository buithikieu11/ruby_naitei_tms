class Task < ApplicationRecord
  belongs_to :subject
  has_many :user_tasks, dependent: :destroy

  validates :name, presence: true
  validates :step, presence: true,
                   numericality: {greater_than: Settings.model.task.step.greater_than}
  validates :duration, presence: true,
                       numericality: {greater_than: Settings.model.task.duration.greater_than}

  scope :find_by_name, ->(name){where("name LIKE ?", "%#{name}%") if name.present?}
end
