require 'rails_helper'

RSpec.describe Project, type: :model do
  let!(:project) { create(:project,
                    title: "Askims 12", 
                    adress: "Askims Kyrkåsväg 12",
                    description: "En beskrivning av projektet.",
                    material_amount: 32000, 
                    misc_amount: 500) }

  before do
    @employee  = create(:employee)
    @checklist1 = create(:checklist, project: project, title: 'ÄTA', amount: 5000, is_rot: false)
    @checklist2 = create(:checklist, project: project, title: 'Work', amount: 134700, is_rot: true)
    @todo      = create(:todo, checklist: @checklist1, description: 'Måla köket.')
  end

  it 'can not be completed if not all todos are completed' do
    project.update(status: 'completed')
    expect(project).to_not be_valid
  end

  describe '#reports' do
    it 'returns all reports for the project' do
      report1 = create(:report, reportable: @checklist1, reportee: @employee)
      travel_to(Date.tomorrow)
      report2 = create(:report, reportable: @checklist1, reportee: @employee)
      travel_back
      report3 = create(:report, reportable: @checklist2)

      expect(@checklist1.reports.count).to eq(2)
      expect(@checklist1.reports).to include(report1, report2)
      expect(project.reports.count).to eq(3)

      @todo.update(completed: true)
      project.update(status: 'completed')
      expect(project.completed_on).to eq(report2.date)
    end
  end

  describe '#hours_reported' do
    it 'returns hours total for all checklists and project' do
      create(:report, time_in_hours: 5, reportable: @checklist1)
      expect(project.hours_reported).to eq(5.0)
      create(:report, time_in_hours: 5, reportable: @checklist2)
      expect(project.reload.hours_reported).to eq(10.0)
    end
  end

  describe '#progress' do
    it 'should return the progress in percent' do
      # There is one @todo already created
      create(:todo, checklist: @checklist1)
      create(:todo, checklist: @checklist1)

      expect(project.progress).to eq(0.0)
      @todo.update(completed: true)
      expect(project.progress).to eq(0.33)
    end

    it 'should return 0 i no projects' do
      expect(create(:project).progress).to eq(0)
    end
  end
end
