require 'rails_helper'

RSpec.describe User, type: :model do
  let(:john) { create(:user, first_name: 'John', last_name: 'Doe', email: 'john@doe.com') }
  let(:jane) { create(:user, first_name: 'Jane', last_name: nil) }
  let(:jim) { create(:user, first_name: nil, last_name: nil) }

  describe "#full_name" do
    it("returns the full name") { expect(john.full_name).to eq("John Doe") }
    it("returns the first name") { expect(jane.full_name).to eq("Jane") }
    it("returns nil as fallback") { expect(jim.full_name).to be_nil }
  end

  describe "#display_name" do
    it("displays fullname") { expect(john.display_name).to eq('John Doe') }
    it("displays firstname") { expect(jane.display_name).to eq('Jane') }
    it("displays email as fallback") { expect(jim.display_name).to eq(jim.email) }
  end
end
