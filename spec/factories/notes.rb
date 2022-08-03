FactoryBot.define do
  factory :note do
    project
    user
    content { "My Text" }
  end
end
