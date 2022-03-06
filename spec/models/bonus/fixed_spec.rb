require 'rails_helper'

RSpec.describe Bonus::Fixed, type: :model do
  describe 'a project with 10000' do
    let(:project)   { create(:project, hourly_rate: 500) }
    let(:checklist) { create(:checklist, amount: 10000, project: project) }
    let(:john)    { create(:worker) }
    let(:jim)     { create(:worker) }
    
    before do
      create(:report, time_in_minutes: 360, checklist: checklist, worker: john)
      create(:report, time_in_minutes: 240, checklist: checklist, worker: jim)
    end

    describe '#worker_hours' do
      it 'returns hours worked by worker' do
        expect(Bonus::Fixed.for(project, john).worker_hours).to eq(6)
        expect(Bonus::Fixed.for(project, jim).worker_hours).to eq(4)
      end
    end

    describe '#worker_percentage' do
      it 'returns hours worked by worker' do
        expect(Bonus::Fixed.for(project, john).worker_percentage).to eq(0.6)
        expect(Bonus::Fixed.for(project, jim).worker_percentage).to eq(0.4)
      end
    end

    describe '#bonus_for' do
      it 'returns total salary expenses' do
        expect(Bonus::Fixed.for(project, john).bonus_total).to eq(2100)
        expect(Bonus::Fixed.for(project, jim).bonus_total).to eq(1400)
      end
    end
  end
end
