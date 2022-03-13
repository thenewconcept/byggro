[Project, Worker, User, Report].each do |_class|
  _class.destroy_all
end

admin   = User.create!( email: 'jane@doe.com', password: 'kallekalle', is_admin: true )
manager = User.create!( email: 'mia@doe.com', password: 'kallekalle', is_manager: true )
worker_user = User.create!( first_name: 'John', last_name: 'Doe', email: 'john@doe.com', password: 'kallekalle' )
worker = Worker.create!( user: worker_user, salary: 160, title: 'Junior' )

# Creates two checklists after save.
project1 = Project.create!(
  title: "Testprojekt", 
  adress: "Viktoriagatan 8",
  description: "En beskrivning av projektet.",
  hourly_rate: 500,
  bonus: 'hourly',
  material_amount: 1000, 
  misc_amount: 1000, 
  is_rot: true
)

# Creates two checklists after save.
project2 = Project.create!(
  title: "Nätverkscentrum", 
  adress: "Elesbobacken 1",
  description: "En beskrivning av projektet.",
  hourly_rate: 500,
  bonus: 'fixed',
  material_amount: 800, 
  misc_amount: 500, 
  is_rot: false
)

project1.checklists.first.update_attribute(:amount, 8000) 
project1.checklists.last.update_attribute(:amount, 2000)

project1.checklists.first.todos.create!(description: 'Måla om köket, första strykning.')
project1.checklists.first.todos.create!(description: 'Måla om köket, andra strykning.')

project1.checklists.last.todos.create!(description: 'Måla fönster.')
project1.checklists.last.todos.create!(description: 'Måla dörrar.')

Report.create!(
  worker: worker,
  checklist: project1.checklists.first,
  time_in_minutes: 8 * 60,
  date: Date.today
)

Report.create!(
  worker: worker,
  checklist: project1.checklists.first,
  time_in_minutes: 2 * 60,
  date: Date.today
)