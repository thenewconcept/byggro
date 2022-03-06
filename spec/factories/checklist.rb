FactoryBot.define do
  factory :checklist do
    project
    title { Faker::Construction.trade }
    amount { 10000 }
  end
end