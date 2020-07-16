class User < ApplicationRecord
  attr_accessor :remember_token

  enum role: {trainee: 0, supervisor: 1}

  has_many :course_users, dependent: :destroy
  has_many :courses, through: :course_users
  has_many :user_tasks, dependent: :destroy
  has_many :tasks, through: :user_tasks
  has_many :user_subjects, dependent: :destroy
  has_many :subjects, through: :user_subjects

  MODEL_SETTINGS = Settings.model.user

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_PHONE_NUMBER_REGEX = /\A\+?[0-9]+\z/.freeze
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9\._]+\z/.freeze

  validates :role, presence: true, inclusion: {in: roles.keys}
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
                           format: {with: VALID_PHONE_NUMBER_REGEX}, allow_blank: true

  has_secure_password

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end
end
