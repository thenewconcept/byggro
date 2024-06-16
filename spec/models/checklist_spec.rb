require 'rails_helper'

RSpec.describe Checklist, type: :model do
  describe '#salary' do
    it 'returns the total salary for the checklist' do
      checklist = create(:checklist, payout: 'hourly')
      report = create(:report, reportable: checklist, reportee: employee, time_in_hours: 10)
    end
  end

  describe 'completed by associated todos' do
    it 'is completed when all todos are completed' do
      finished_checklist = create(:checklist, todos: [create(:todo, completed: true), create(:todo, completed: true)])
      in_progress_checklist = create(:checklist, todos: [create(:todo, completed: false), create(:todo, completed: true)])

      expect(finished_checklist).to be_completed
      expect(in_progress_checklist).to_not be_completed
    end
  end
end