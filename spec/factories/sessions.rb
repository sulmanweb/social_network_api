FactoryBot.define do
  factory :session do
    association :user
    status true
  end
end
