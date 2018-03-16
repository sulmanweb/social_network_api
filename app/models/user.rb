class User < ApplicationRecord
  has_secure_password
  # Email Validations
  validates :email, presence: true, uniqueness: true, format: {with: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/, message: I18n.t('errors.users.format_email')}

  # Username Validations
  validates :username, presence: true, uniqueness: true, format: {with: /\A([a-z\d_]){1,15}\z/, message: I18n.t('errors.users.format_username')}

  # Password Validations
  validates :password, format: {with: /\A(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[\W]).{8,72}\z/, message: I18n.t('errors.users.format_password')}, if: :password_required?

  validates :password_confirmation, presence: true, if: :password_required?

  ## Relationships
  has_many :sessions, dependent: :destroy

  private

  # is password required for user?
  def password_required?
    password_digest.nil? || !password.blank?
  end
end
