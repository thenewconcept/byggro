FactoryBot.define do
  factory :checklist do
    project
    title { Faker::Construction.trade }
    amount { 10000 }
    is_rot { false }
  end
end