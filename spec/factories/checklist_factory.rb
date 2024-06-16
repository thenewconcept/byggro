FactoryBot.define do
  factory :checklist do
    project
    payout { 'hourly' }
    title { Faker::Construction.trade }
    hourly_rate { 500 }
  end

  trait :fixed do
    payout { 'fixed' }
    amount { 10000 }
  end
end