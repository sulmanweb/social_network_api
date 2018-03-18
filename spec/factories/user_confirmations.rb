FactoryBot.define do
  factory :user_confirmation do
    association :user
    c_type "email_confirmation"
    status "pending"
  end
end
