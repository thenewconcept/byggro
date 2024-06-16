require 'rails_helper'

RSpec.describe Checklist, type: :model do
  describe 'completed by associated todos' do
    it 'is completed when all todos are completed' do
      finished_checklist = create(:checklist, todos: [create(:todo, completed: true), create(:todo, completed: true)])
      in_progress_checklist = create(:checklist, todos: [create(:todo, completed: false), create(:todo, completed: true)])

      expect(finished_checklist).to be_completed
      expect(in_progress_checklist).to_not be_completed
    end
  end
end