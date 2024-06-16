FactoryBot.define do
  factory :checklist do
    project
    bonus { 'none' }
    title { Faker::Construction.trade }
    hourly_rate { 500 }
  end

  trait :fixed do
    bonus { 'fixed' }
    amount { 10000 }
  end
end