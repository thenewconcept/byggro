FactoryBot.define do
  factory :expense do
    user
    project
    spent_on { Date.today }
    amount { 1000 }
    category { 'material' }
    description { Faker::Lorem.sentence }
  end
end