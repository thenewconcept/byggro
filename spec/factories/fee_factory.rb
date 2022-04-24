FactoryBot.define do
  factory :fee do
    reportee { create(:employee) }
    amount { 100 }
  end
end
