class UserSubject < ApplicationRecord
  enum status: {pending: 0, started: 1, finished: 2}

  belongs_to :user
  belongs_to :subject
end
