class Session < ApplicationRecord
  belongs_to :user
  validates :uid, presence: true, uniqueness: true, length: {is: UID_LENGTH}
  ## SCOPES
  scope :active_sessions, -> {where status: true}

  ## MODEL FUNCTIONS CALLINGS
  before_validation :generate_uid, on: :create
  after_create :current_time_to_last_user_at

  private

  # Generate random unique utoken for the model
  def generate_uid
    self.uid = loop do
      random_token = SecureRandom.base58(UID_LENGTH)
      break random_token unless Session.exists?(uid: random_token)
    end
  end

  def current_time_to_last_user_at
    self.update(last_used_at: Time.zone.now)
  end
end
