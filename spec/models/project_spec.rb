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

  describe 'General reports' do
    it '#hours_reported' do
      project   = create(:project, hourly_rate: 500)
      checklist = create(:checklist, amount: 10000, project: project)
      create(:report, time_in_minutes: 300, checklist: checklist)
      expect(project.hours_reported).to eq(5)
      create(:report, time_in_minutes: 300, checklist: checklist)
      expect(project.hours_reported).to eq(10)
    end
  end

  describe 'Bonus calculations' do
    it '#bonus_percent' do
      project   = create(:project, hourly_rate: 500)
      checklist = create(:checklist, amount: 10000, project: project)
      report    = create(:report, time_in_minutes: 300, checklist: checklist)
      expect(project.bonus_percent).to eq(0.75)
      report    = create(:report, time_in_minutes: 300, checklist: checklist)
      expect(project.bonus_percent).to eq(0.5)
    end

    it '#hourly_percent' do
      project   = create(:project, hourly_rate: 500)
      checklist = create(:checklist, amount: 10000, project: project)
      create(:report, time_in_minutes: 300, checklist: checklist)
      expect(project.hourly_percent).to eq(0.25)
      create(:report, time_in_minutes: 300, checklist: checklist)
      expect(project.hourly_percent).to eq(0.50)
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
