class Post < ApplicationRecord
  belongs_to :user

  validates :body, presence: true

  has_many :comments, dependent: :destroy
end
