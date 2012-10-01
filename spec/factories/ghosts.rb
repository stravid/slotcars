FactoryGirl.define do
  factory :ghost do
    time { Random.rand 10000 }
    user
    track
  end
end
