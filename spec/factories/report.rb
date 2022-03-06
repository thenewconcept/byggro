FactoryBot.define do
  factory :report do
    worker
    checklist
    date { Date.today }
    time_in_minutes { 60 }
    note { Faker::Lorem.sentence }
  end
end