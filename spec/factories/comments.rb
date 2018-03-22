FactoryBot.define do
  factory :comment do
    association :user
    association :post
    body "MyText"
  end
end
