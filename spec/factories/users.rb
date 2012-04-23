# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "person#{n}" }
    sequence(:email) {|n| "person#{n}@example.com" }
    password "password"
  end
end
