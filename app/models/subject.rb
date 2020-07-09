class Subject < ApplicationRecord
  enum status: {pending: 0, started: 1, finished: 2}

  VALID_NAME_REGEX = /\A[a-zA-Z0-9 ]+\z/i.freeze

  validates :name, presence: true,
                   format: { with: VALID_NAME_REGEX }
  validates :status, presence: true,
                     numericality: true,
                     inclusion: { in: statuses.keys }
end
