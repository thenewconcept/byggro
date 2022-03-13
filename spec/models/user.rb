require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a display name' do
    expect(create(:user, email: 'john@doe.com').display_name).to eq('john@doe.com')
    expect(create(:user, first_name: 'John', last_name: 'Doe').display_name).to eq('John Doe')
    expect(create(:user, first_name: 'John', last_name: nil).display_name).to eq('John')
  end
end
