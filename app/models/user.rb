class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest
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

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attributes remember_digest: nil
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
