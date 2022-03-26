require 'rails_helper'

RSpec.describe 'worker user interface' do
  let(:user)    { create(:user) }
  let(:worker)  { create(:worker, user: user) }
  let(:project) { create(:project) }
  let(:todo1)   { create(:todo, description: 'Måla köket.', checklist: project.checklists.first ) }
  let(:todo2)   { create(:todo, description: 'Måla vardagsrum.', checklist: project.checklists.first ) }

  before :each do
    project.checklists.first.update_attribute(:amount, 10000)
  end

  it 'does not display admin data' do
    create(:user, email: 'jinx@doe.com', password: '12345678')
    visit root_path
    fill_in :email, with: 'jinx@doe.com'
    fill_in :password, with: '12345678'
    click_button 'Logga in'
    expect(page).to have_content(project.title)
  end
end