require 'rails_helper'

RSpec.describe Report, type: :model do
  describe 'creating with hours' do
    it 'accepst hours as an attribute' do
      report = create(:report, time_in_hours: 1)
      expect(report.time_in_minutes).to eq(60)
    end
  end
end
