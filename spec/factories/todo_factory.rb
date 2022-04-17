FactoryBot.define do
  factory :todo do
    checklist
    description { Faker::Lorem.sentence }
  end
end