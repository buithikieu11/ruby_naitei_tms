class Course < ApplicationRecord
  enum status: {pending: 0, started: 1, finish: 2}
  validates :name, uniqueness: {case_sensitive: false},
                   presence: true,
                   length: {maximum: Settings.model.course.name.max_length},
                   format: {with: /\A[a-zA-Z0-9 ]+\z/}
  validates :description, presence: true
  validates :status, presence: true, inclusion: {in: statuses.keys}
  validates :day_start, presence: true
  validate  :day_start_is_lower_than_day_end

  def day_start_is_lower_than_day_end
    errors.add(:invalid_date, "day_start_is_lower_than_day_end") if day_start >= day_end
  end
end
