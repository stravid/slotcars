FactoryGirl.define do
  factory :run do
    time { Random.rand 10000 }
  end
end
