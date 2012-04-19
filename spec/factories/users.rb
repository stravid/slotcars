# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username "admin"
    email "admin@slotcars.com"
    password "password"
  end
end
