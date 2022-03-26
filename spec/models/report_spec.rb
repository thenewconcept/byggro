require 'rails_helper'

RSpec.describe Report, type: :model do
  describe 'creating with hours' do
    it 'accepst hours as an attribute' do
      report = create(:report, time_in_hours: 1)
      expect(report.time_in_minutes).to eq(60)
    end
  end

  describe '.by_project' do
    it 'returns reports by project' do
      project   = create(:project)
      checklist = create(:checklist, project: project)
      p_report    = create(:report, reportable: checklist)
      c_report    = create(:report, reportable: project)
      expect(Report.by_project(project)).to eq([p_report, c_report])
    end
  end
end
