require 'rails_helper'

RSpec.describe 'Projects' do
  let!(:admin)  { create(:user, :admin) }
  let!(:user)  { create(:user, first_name: 'John', last_name: 'Doe', email: 'john@doe.com', employee: create(:employee)) }

  context 'as a employee' do
    before do
      create(:project, :upcoming, title: 'Assigned Project', users: [user])
      create(:project, :upcoming, title: 'Unassigned Project')
      create(:project, title: 'Draft Project', users: [user])

      visit root_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Logga in'
    end

    it 'can see non-draft projects' do
      click_link 'Kommande'
      expect(page).to have_content('Assigned Project')
      expect(page).to have_content('Unassigned Project')
    end

    it 'can not see draft projects' do
      expect(page).to_not have_content('Utkast')
    end
  end

  context 'as an admin' do
    before do
      create(:project, :upcoming, title: 'Assigned Project', users: [user])
      create(:project, :upcoming, title: 'Unassigned Project')
      create(:project, title: 'Draft Project', users: [user])

      visit root_path
      fill_in :email, with: admin.email
      fill_in :password, with: admin.password
      click_button 'Logga in'
    end

    it 'can see all assignments' do
      click_link 'Kommande'
      expect(page).to have_content('Assigned Project')
      expect(page).to have_content('Unassigned Project')
      click_link 'Utkast'
      expect(page).to have_content('Draft Project')
    end

    it 'can see the internal tab of a project' do
      project = create(:project, :started, title: 'Ongoing Project')

      visit project_path(project, tab: 'internal')

      expect(page).to have_content('Ongoing Project')
      expect(page).to have_content('Kostnader')
    end

    it 'can see the admin tab of a project' do
      project = create(:project, :started, title: 'Ongoing Project')
      checklist = project.checklists.create(title: 'Checklist 1', payout: :hourly)
      report = checklist.reports.create(time_in_hours: 10, reportee: build(:employee)) 

      visit project_path(project, tab: 'admin')

      expect(page).to have_content('Ongoing Project')
    end
  end
end