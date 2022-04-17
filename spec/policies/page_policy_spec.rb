require 'rails_helper'

RSpec.describe PagePolicy, type: :policy do
  let(:employee) { create(:employee) }
  let(:intern) { create(:employee) }
  let(:contractor) { create(:employee) }

  subject { described_class }

  permissions ".scope" do
    before do
      employee_page = create(:page, access: ['Anställd'])
      workers_page = create(:page, access: ['Anställd', 'Praktikant'])
      contractor_page = create(:page, access: ['Underentrepenör'])
    end

    it "returns everything for a super admin" do
      scope = Pundit.policy_scope!(employee.user, Page)
      expect(scope.count).to eq(2)
    end
  end
end
