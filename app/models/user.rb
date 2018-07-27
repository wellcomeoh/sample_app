class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save :downcase_email
  validates :name, presence: true,
    length: {maximum: Settings.model.user.name.max}
  validates :email, format: {with: VALID_EMAIL_REGEX},
    presence: true,
    uniqueness: {case_sensitive: false},
    length: {maximum: Settings.model.user.email.max}
  validates :password, presence: true,
    length: {minimum: Settings.model.user.password.min}
  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
