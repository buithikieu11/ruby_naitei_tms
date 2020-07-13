class User < ApplicationRecord
  enum role: {trainee: 0, supervisor: 1}

  MODEL_SETTINGS = Settings.model.user
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_PHONE_NUMBER_REGEX = /\A\+?[0-9]+\z/.freeze
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9]+\z/.freeze

  validates :role, numericality: true, inclusion: {in: roles}
  validates :username, presence: true,
                       uniqueness: {case_sensitive: false},
                       length: {minimum: MODEL_SETTINGS.username.min_length,
                                maximum: MODEL_SETTINGS.username.max_length},
                       format: {with: VALID_USERNAME_REGEX}
  validates :password, presence: true
  validates :email, presence: true,
                    uniqueness: {case_sensitive: false},
                    length: {maximum: MODEL_SETTINGS.email.max_length},
                    format: {with: VALID_EMAIL_REGEX}
  validates :phone_number, length: {minimum: MODEL_SETTINGS.phone_number.min_length,
                                    maximum: MODEL_SETTINGS.phone_number.max_length},
                           format: {with: VALID_PHONE_NUMBER_REGEX}

  has_secure_password
end
