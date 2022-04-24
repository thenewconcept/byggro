require 'rails_helper'

RSpec.describe Report, type: :model do
  describe 'creating a report' do
    it 'persists the reportee fee at the given date' do
      travel_to Time.parse('2020-01-01')
      employee   = create(:employee, fee: 100)
      contractor = create(:contractor, fee: 400)

      travel_to Time.parse('2021-01-01')
      employee.update_attribute(:fee, 200)
      contractor.update_attribute(:fee, 500)

      e2020 = create(:report, reportee: employee, date: '2020-01-02')
      c2020 = create(:report, reportee: contractor, date: '2020-01-02')

      e2021 = create(:report, reportee: employee, date: '2021-01-02')
      c2021 = create(:report, reportee: contractor, date: '2021-01-02')

      expect(e2020.fee).to eq(100)
      expect(c2020.fee).to eq(400)

      expect(e2021.fee).to eq(200)
      expect(c2021.fee).to eq(500)
    end
  end

  describe 'when missing fee on date' do
    it 'raises an error' do
      travel_to Time.parse('2022-01-01')
      employee = create(:employee, fee: 100)
      report = build(:report, reportee: employee, date: '2021-01-01')
      expect(report).to_not be_valid
      expect(report.errors[:fee].first).to eq('kunde inte hittas')
    end
  end

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
      p_report  = create(:report, reportable: checklist)
      c_report  = create(:report, reportable: project)
      create(:report)

      expect(Report.by_project(project)).to eq([p_report, c_report])
    end
  end
end