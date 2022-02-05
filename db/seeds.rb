[Project, User].each do |_class|
  _class.destroy_all
end

User.create!(
  email: 'jane@doe.com',
  password: 'kallekalle',
)

project1 = Project.create!(
  title: "Askims 12", 
  adress: "Askims Kyrkåsväg 12",
  description: "En beskrivning av projektet.",
  work_amount: 134700, 
  material_amount: 32000, 
  misc_amount: 500, 
  is_rot: true
)

project2 = Project.create!(
  title: "Nätverkscentrum", 
  adress: "Elesbobacken 1",
  description: "En beskrivning av projektet.",
  work_amount: 32000, 
  material_amount: 800, 
  misc_amount: 500, 
  is_rot: false
)

project1.checklists.first.todos.create!(description: 'Kläder')
project1.checklists.first.todos.create!(description: 'Mat')

project1.checklists.last.todos.create!(description: 'Kläder')
project1.checklists.last.todos.create!(description: 'Mat')