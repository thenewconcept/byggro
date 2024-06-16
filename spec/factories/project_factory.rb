FactoryBot.define do
  factory :project do
    client
    title { "Vasa Målarjobb" }
    adress { "Viktoriagatan 1" }
    description  { "En beskrivning av projektet." }
    material_amount { 1000 } 
    misc_amount { 500  }
  end


  trait :upcoming do
    status { 'completed' }
  end

  trait :started do
    status { 'started' }
  end

  trait :completed do
    status { 'completed' }
  end
end
