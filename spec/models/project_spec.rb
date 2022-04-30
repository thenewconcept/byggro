require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @employee = create(:employee)
    @project = create(:project,
      title: "Askims 12", 
      adress: "Askims Kyrkåsväg 12",
      description: "En beskrivning av projektet.",
      material_amount: 32000, 
      misc_amount: 500) 
    @checklist = create(:checklist, project: @project, title: 'Work', amount: 134700)
    @todo = create(:todo, checklist: @checklist, description: 'Måla köket.')
  end

  it 'can not be completed if not all todos are completed' do
    @project.update(status: 'completed')
    expect(@project).to_not be_valid
  end

  describe '#reports' do
    it 'returns all reports for the project' do
      report1 = create(:report, reportable: @project, reportee: @employee)

      travel_to(Date.tomorrow)
      report2 = create(:report, reportable: @checklist, reportee: @employee)
      travel_back

      report3 = create(:report)

      expect(@project.reports.count).to eq(2)
      expect(@project.reports).to eq([report1, report2])
      expect(@project.reports).to eq(Report.by_project(@project))

      @todo.update(completed: true)
      @project.update(status: 'completed')
      expect(@project.completed_at).to eq(report2.date)
    end
  end

  describe '#hours_reported' do
    it 'returns hours tota for all checklists and project' do
      project   = create(:project, hourly_rate: 500)
      checklist = create(:checklist, amount: 10000, project: project)

      create(:report, time_in_hours: 5, reportable: checklist)
      expect(project.hours_reported).to eq(5.0)

      create(:report, time_in_hours: 5, reportable: checklist)
      expect(project.hours_reported).to eq(10.0)
    end
  end

  describe '#progress' do
    it 'should return the progress in percent' do
      # There is one @todo already created
      create(:todo, checklist: @checklist)
      create(:todo, checklist: @checklist)

      expect(@project.progress).to eq(0.0)
      @todo.update(completed: true)
      expect(@project.progress).to eq(0.33)
    end

    it 'should return 0 i no projects' do
      expect(create(:project).progress).to eq(0)
    end
  end

  describe 'ROT calculations' do
    it 'proper calculations' do
      expect(@project.total).to eq(167200)
      expect(@project.client_costs).to eq(169000)
      expect(@project.client_costs).to eq(169000)
      expect(@project.client_payed).to eq(118487.5)
      expect(@project.rot).to eq(50512.5)
    end
  end
end
