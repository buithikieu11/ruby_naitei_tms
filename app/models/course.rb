class Course < ApplicationRecord
  enum status: {pending: 0, started: 1, finished: 2}

  has_many :course_users, dependent: :destroy
  has_many :users, through: :course_users
  has_many :course_subjects, dependent: :destroy
  has_many :subjects, through: :course_subjects
  VALID_NAME_REGEX = /\A[a-zA-Z0-9 ]+\z/
  validates :name, uniqueness: { case_sensitive: false }, 
                   presence: true,
                   length: {maximum: Settings.model.course.name.max_length},
                   format: {with: VALID_NAME_REGEX}
  validates :description, presence: true
  validates :status, presence: true, inclusion: {in: statuses.keys}
  validates :day_start, presence: true
  validates :day_end, presence: true
  validate  :day_start_is_lower_than_day_end
  scope :sort_by_created_at, ->{order('created_at DESC')}
  scope :search_by_name, ->(name){where "lower(name) LIKE ?", "%#{name}%"}
  scope :by_ids, ->(ids){where id: ids}
  scope :by_status, ->(status){where status: status}

  def day_start_is_lower_than_day_end
    if day_start.present? &&day_end.present?
    errors.add(:invalid_date, I18n.t("model.course.invalid_date_message")) if day_start > day_end
    end
  end
end
