FactoryBot.define do
  factory :report do
    reportee { create(:employee) }
    reportable { create(:checklist) }
    date { Date.today }
    time_in_minutes { 60 }
    note { Faker::Lorem.sentence }
  end
end