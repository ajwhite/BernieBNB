FactoryGirl.define do
  factory :available_host_range do |f|
    f.hosting_id 1
    f.start_date { DateTime.now }
    f.end_date { DateTime.now + 5 }
  end

end
