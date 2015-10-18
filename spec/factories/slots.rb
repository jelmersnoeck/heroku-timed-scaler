FactoryGirl.define do
  factory :slot do
    from { Time.now }
    to { 1.day.from_now }
    cancelled false
    formation_size 1
    formation_initial_size "hobby"
    formation_type "web"

    trait :cancelled do
      cancelled true
    end
  end
end
