FactoryBot.define do
  factory :employee do
    user
    salary { 100 }
    title { "John Doe" }
  end
end
