require 'rails_helper'

RSpec.describe 'reports', :js do
  let(:employee)  { create(:employee) }
  let(:contractor) { create(:contractor)}
  let(:project) { create(:project, :started) }
  let(:todo1)   { create(:todo, description: 'Måla köket.', checklist: project.checklists.first ) }
  let(:todo2)   { create(:todo, description: 'Måla vardagsrum.', checklist: project.checklists.first ) }

  before :each do
    project.checklists.first.update_attribute(:amount, 10000)
  end

  context 'as a employee' do
    before do
      visit root_path
      fill_in :email, with: employee.email
      fill_in :password, with: employee.password
      click_button 'Logga in'
    end

    context 'can be created' do
      it 'for checklist' do
        click_link project.title
        click_link 'Arbetsmoment' 

        within "#checklist_#{project.checklists.first.id}" do
          click_link 'Tidrapport'
        end

        fill_in :report_time_formated, with: '2:30'
        fill_in :report_note, with: 'Tidrapport för arbetsmomentet.'
        click_on 'Spara'

        expect(page).to have_content('2.5')
      end
    end
  end

  context 'as a contractor' do
    before do
      visit root_path
      fill_in :email, with: contractor.email
      fill_in :password, with: contractor.password
      click_button 'Logga in'
    end

    it 'can be created' do
      click_link project.title
      click_link 'Arbetsmoment' 

      within "#checklist_#{project.checklists.first.id}" do
        click_link 'Tidrapport'
      end

      fill_in :report_time_formated, with: '2:30'
      fill_in :report_note, with: 'Tidrapport för arbetsmomentet.'
      click_on 'Spara'

      expect(page).to have_content('2.5')
    end
  end
end