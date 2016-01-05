FactoryGirl.define do
  factory :hosting do |f|
    f.host_id { rand(1..5) }
    f.zipcode { Faker::Address.zip }
    f.max_guests { rand(1..10) }
  end

end
