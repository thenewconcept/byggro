require 'rails_helper'

RSpec.describe 'User management' do
  let!(:admin) { create(:user, :admin) }
  let!(:user)  { create(:user, first_name: 'John', last_name: 'Doe', email: 'john@doe.com') }

  context 'as an admin' do
    before do
      visit root_path
      fill_in :email, with: admin.email
      fill_in :password, with: admin.password
      click_button 'Logga in'
      find('#mobile-menu').click_link('Användare')
    end

    it 'can list all users' do
      expect(page).to have_content('John Doe')
      expect(page).to have_content(admin.display_name)
    end

    it 'can edit a user' do
      within("#user_#{user.id}") do
        click_on('Ändra')
      end

      fill_in 'Efternamn', with: 'Dae'
      click_button 'Spara'
      find('#mobile-menu').click_link('Användare')

      expect(page).to have_content('John Dae')
    end
  end

end