FactoryBot.define do
  factory :post do
    association :user
    body "MyText"
  end
end
