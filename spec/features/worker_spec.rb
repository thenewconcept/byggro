require 'rails_helper'

RSpec.describe 'worker user interface' do
  let(:user)    { create(:user) }
  let(:worker)  { create(:worker, user: user) }
  let(:project) { create(:project) }

  it 'only sees published projects' do
    visit root_path
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Logga in'

    expect(page).to_not have_content(project.title)
    project.update_attribute(:status, 'started')

    visit root_path
    expect(page).to have_content(project.title)
  end
end