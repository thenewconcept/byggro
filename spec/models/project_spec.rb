require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @project = create(:project,
      title: "Askims 12", 
      adress: "Askims Kyrkåsväg 12",
      description: "En beskrivning av projektet.",
      material_amount: 32000, 
      misc_amount: 500) 
    @checklist = create(:checklist, project: @project, title: 'Work', amount: 134700)
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
      10.times { create(:todo, checklist: @checklist) } 
      @project.todos.last.update(completed: true)
      @project.todos.first.update(completed: true)
      expect(@project.progress).to eq(0.2)
    end

    it 'should return the progress in percent' do
      10.times { create(:todo, checklist: @checklist) } 
      @project.todos.last.update(completed: true)
      @project.todos.first.update(completed: true)
      expect(@project.progress).to eq(0.2)
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
