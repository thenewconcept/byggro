require 'rails_helper'

RSpec.describe 'Assignments' do
  let!(:admin)  { create(:user, :admin) }
  let!(:user)  { create(:user, first_name: 'John', last_name: 'Doe', email: 'john@doe.com', worker: create(:worker)) }

  context 'as a worker' do
    before do
      create(:project, :upcoming, title: 'Assigned Project', users: [user])
      create(:project, :upcoming, title: 'Unassigned Project')
      create(:project, title: 'Draft Project', users: [user])

      visit root_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Logga in'
    end

    it 'can see his assignments' do
      expect(page).to have_content('Assigned Project')
      expect(page).to_not have_content('Unassigned Project')
    end

    it 'can not see draft projects' do
      expect(page).to_not have_content('Draft Project')
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

    it 'can see ALL assignments' do
      expect(page).to have_content('Assigned Project')
      expect(page).to have_content('Unassigned Project')
      expect(page).to have_content('Draft Project')
    end
  end
end