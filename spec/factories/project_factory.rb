FactoryBot.define do
  factory :project do
    title { "Vasa Målarjobb" }
    adress { "Viktoriagatan 1" }
    description  { "En beskrivning av projektet." }
    bonus { 'none' }
    hourly_rate { 500 }
    material_amount { 1000 } 
    misc_amount { 500  }
    is_rot { false }
  end

  trait :none do
    bonus { 'none' }
  end

  trait :fixed do
    bonus { 'fixed' }
  end

  trait 'hourly' do
    bonus { 'hourly' }
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
