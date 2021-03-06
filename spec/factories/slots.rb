FactoryGirl.define do
  factory :slot do
    from { Time.now }
    to { 1.day.from_now }
    cancelled false
    formation_size 'standard-1x'
    formation_type "web"
    formation_quantity 2

    trait :cancelled do
      cancelled true
    end

    trait :future do
      from { 1.day.from_now }
      to { 2.days.from_now }
    end

    trait :passed do
      from { 2.days.ago }
      to { 1.day.ago }
    end

    trait :active do
      from { 2.days.ago }
      to { 1.day.from_now }
    end

    trait :scaled do
      formation_initial_quantity 3
      formation_initial_size "hobby"
    end
  end
end
