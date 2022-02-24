[Project, User].each do |_class|
  _class.destroy_all
end

admin   = User.create!( email: 'jane@doe.com', password: 'kallekalle', is_admin: true )
manager = User.create!( email: 'mia@doe.com', password: 'kallekalle', is_manager: true )
worker  = User.create!( email: 'john@doe.com', password: 'kallekalle' )
          Worker.create!( user: worker, salary: 160, title: 'Junior' )

# Creates two checklists after save.
project1 = Project.create!(
  title: "Askims Paradis", 
  adress: "Askims Kyrkåsväg 12",
  description: "En beskrivning av projektet.",
  work_amount: 134700, 
  material_amount: 32000, 
  misc_amount: 500, 
  is_rot: true
)

# Creates two checklists after save.
project2 = Project.create!(
  title: "Nätverkscentrum", 
  adress: "Elesbobacken 1",
  description: "En beskrivning av projektet.",
  work_amount: 32000, 
  material_amount: 800, 
  misc_amount: 500, 
  is_rot: false
)

project1.checklists.first.todos.create!(description: 'Måla om köket, första strykning.')
project1.checklists.first.todos.create!(description: 'Måla om köket, andra strykning.')

project1.checklists.last.todos.create!(description: 'Måla fönster.')
project1.checklists.last.todos.create!(description: 'Måla dörrar.')