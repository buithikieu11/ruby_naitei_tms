class Subject < ApplicationRecord
  has_many :course_subjects, dependent: :destroy
  has_many :courses, through: :course_subjects
  has_many :user_subjects, dependent: :destroy
  has_many :users, through: :user_subjects
  has_many :tasks, dependent: :destroy

  validates :name, presence: true

  accepts_nested_attributes_for :tasks, allow_destroy: true,
                                reject_if: proc{|att| att['name'].blank?}

  scope :find_by_name, ->(name){where("name LIKE ?", "%#{name}%")}
  scope :sort_by_name, ->{order('name ASC')}
end
