require 'rails_helper'

RSpec.describe 'login' do
  it 'works with a valid user' do
    user = create(:user, email: 'jinx@doe.com', password: '12345678')
    visit root_path
    fill_in :email, with: 'jinx@doe.com'
    fill_in :password, with: '12345678'
    click_button 'Logga in'
    expect(page).to have_content('Signed in successfully.')
  end
end