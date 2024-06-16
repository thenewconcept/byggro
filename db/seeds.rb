[Report, Project, Employee, Contractor, User, Client].each do |_class|
  _class.destroy_all
end

require 'active_support/testing/time_helpers'
include ActiveSupport::Testing::TimeHelpers

travel_to(DateTime.now - 2.weeks)

admin   = User.create!( email: 'jane@doe.com', password: 'kallekalle', is_admin: true )
manager = User.create!( email: 'jay@doe.com', password: 'kallekalle', is_manager: true )

employee_user = User.create!( first_name: 'John', last_name: 'Doe', email: 'john@doe.com', password: 'kallekalle' )
employee = Employee.create!( user: employee_user, salary: 100, title: 'Senior' )

intern_user = User.create!( first_name: 'Jim', last_name: 'Doe', email: 'jim@doe.com', password: 'kallekalle' )
intern = Intern.create!( user: intern_user )

contractor_user = User.create!( first_name: 'Jake', last_name: 'Doe', email: 'jake@doe.com', password: 'kallekalle' )
contractor = Contractor.create!( user: contractor_user, fee: 400 )

client_user = User.create!( first_name: 'Mia', last_name: 'Doe', email: 'mia@doe.com', password: 'kallekalle' )
client = Client.create!( user: client_user )

travel_back

# Creates two checklists after save.
hourly_project = Project.create!(
  client: client,
  status: "started",
  title: "Timbonus Projekt", 
  adress: "Viktoriagatan 8",
  description: "En beskrivning av projektet.",
  # hourly_rate: 500,
  # bonus: 'hourly',
  material_amount: 10000, 
  misc_amount: 1000, 
  contractors: [contractor]
)

# Creates two checklists after save.
fixed_project = Project.create!(
  client: client,
  status: "started",
  title: "Fastlön Projekt",
  adress: "Elesbobacken 1",
  description: "En beskrivning av projektet.",
  hourly_rate: 500,
  bonus: 'fixed',
  material_amount: 8000, 
  misc_amount: 500, 
  contractors: [contractor]
)

hourly_project.checklists.first.update(amount: 20000, is_rot: true) 
hourly_project.checklists.first.todos.create!(description: 'Måla om huset, första strykning.')
hourly_project.checklists.first.todos.create!(description: 'Måla om huset, andra strykning.')
Report.create!( reportee: intern,   reportable: hourly_project.checklists.first, time_in_hours: 8, date: Date.today)
Report.create!( reportee: employee, reportable: hourly_project.checklists.first, time_in_hours: 8, date: Date.today)
Report.create!( reportee: contractor, reportable: hourly_project.checklists.first, time_in_hours: 4, date: Date.yesterday)
Report.create!( reportee: employee, reportable: hourly_project.checklists.first, time_in_hours: 8, date: Date.yesterday)
Report.create!( reportee: employee, reportable: hourly_project.checklists.first, time_in_hours: 2, date: Date.yesterday)

fixed_project.checklists.first.update_attribute(:amount, 33333) 
fixed_project.checklists.first.todos.create!(description: 'Måla om huset, första strykning.')
fixed_project.checklists.first.todos.create!(description: 'Måla om huset, andra strykning.')
Report.create!( reportee: intern,   reportable: fixed_project.checklists.first, time_in_hours: 8, date: Date.today)
Report.create!( reportee: employee, reportable: fixed_project.checklists.first, time_in_hours: 8, date: Date.today)
Report.create!( reportee: employee, reportable: fixed_project.checklists.first, time_in_hours: 2, date: Date.today)
Report.create!( reportee: contractor, reportable: fixed_project.checklists.first, time_in_hours: 4, date: Date.yesterday)
Report.create!( reportee: employee, reportable: fixed_project.checklists.first, time_in_hours: 8, date: Date.yesterday)
Report.create!( reportee: employee, reportable: fixed_project.checklists.first, time_in_hours: 2, date: Date.yesterday)