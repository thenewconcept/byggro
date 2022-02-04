[Project].each do |_class|
  _class.destroy_all
end

Project.create!(
  title: "Askims 12", 
  adress: "Askims Kyrkåsväg 12",
  description: "En beskrivning av projektet.",
  work_amount: 134700, 
  material_amount: 32000, 
  misc_amount: 500, 
)