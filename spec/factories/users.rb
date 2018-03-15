FactoryBot.define do
  factory :user do
    name "Sulman Baig"
    sequence(:email) {|n| "sbaig#{n}@gmail.com"}
    sequence(:username) {|n| "sulmanweb#{n}"}
    password "abcd@1234"
    password_confirmation "abcd@1234"
  end
end
