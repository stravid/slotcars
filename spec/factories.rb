FactoryGirl.define do
  factory :track do
    raphael     { FactoryGirl.generate :valid_raphael_path }
    rasterized  'rasterizedPath'
  end

  sequence :valid_raphael_path do |n|
    "M90.00R40.00,9.00,45.00,#{n}.00,17.00z"
  end

  sequence :invalid_raphael_path do |n|
    "string#{n}"
  end

end