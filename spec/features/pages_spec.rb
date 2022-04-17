require 'rails_helper'

RSpec.describe 'pages' do
  let(:admin)  { create(:user, :admin) }

  let(:employee)  { create(:employee) }
  let(:contractor) { create(:contractor)}

  context 'as admin' do
    before do
      visit root_path
      fill_in :email, with: admin.email
      fill_in :password, with: admin.password
      click_button 'Logga in'
    end

    it 'can be created' do
      within('#mobile-nav') do
        click_link 'Dokument'
      end

      click_link 'Nytt dokument'

      fill_in :page_title, with: 'For Employees'
      check 'page_employee', allow_label_click: true
      click_on 'Spara'

      using_session("Anställd") do
        visit root_path
        fill_in :email, with: employee.email
        fill_in :password, with: employee.password
        click_button 'Logga in'
  
        within('#mobile-nav') do
          click_link 'Dokument'
        end
        expect(page).to have_content("For Employees")
      end

      using_session("Contractor") do
        visit root_path
        fill_in :email, with: contractor.email
        fill_in :password, with: contractor.password
        click_button 'Logga in'
  
        within('#mobile-nav') do
          click_link 'Dokument'
        end
        expect(page).to_not have_content("For Employees")
      end
    end
  end
end