class UserConfirmation < ApplicationRecord
  belongs_to :user
  enum status: [:pending, :approved, :late]
  enum c_type: [:email_confirmation, :reset_password]
  validates :status, presence: true, inclusion: {in: statuses.keys}
  validates :c_type, presence: true, inclusion: {in: c_types.keys}
  validates :token, presence: true, uniqueness: true, length: {is: UID_LENGTH}

  before_validation :generate_token, on: :create

  private

  # Generate random unique utoken for the model
  def generate_token
    self.token = loop do
      random_token = SecureRandom.base58(UID_LENGTH)
      break random_token unless UserConfirmation.exists?(token: random_token)
    end
  end
end
