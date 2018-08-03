class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_accessor :remember_token
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

  class << self
    def self.digest string
      cost = if ActiveModel::SecurePassword.min_cost
               cost = BCrypt::Engine::MIN_COST
             else
               cost = BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def self.new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attributes remember_digest: nil
  end

  private

  def downcase_email
    email.downcase!
  end
end
