FactoryBot.define do
  factory :worker do
    user
    salary { 100 }
    title { "John Doe" }
  end
end
