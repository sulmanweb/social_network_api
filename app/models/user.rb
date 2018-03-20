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
  has_many :user_confirmations, dependent: :destroy
  has_many :posts, dependent: :destroy

  after_create :send_confirmation

  def confirmed?
    !self.confirmed_at.nil?
  end

  private

  # is password required for user?
  def password_required?
    password_digest.nil? || !password.blank?
  end

  # Send confirmation email
  def send_confirmation
    unless self.confirmed?
      user_confirmation = UserConfirmation.create(user: self, c_type: :email_confirmation)
      UserMailer.confirmation(self.id, user_confirmation.id).deliver_later
    end
  end
end
