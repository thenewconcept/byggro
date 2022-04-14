require 'rails_helper'

RSpec.describe Bonus::Fixed, type: :model do
  describe 'a project with 10000' do

    ENV['BONUS_FIXED'] = '0.35'

    let(:project)   { create(:project, hourly_rate: 500) }
    let(:checklist) { create(:checklist, amount: 10000, project: project) }
    let(:john)    { create(:employee) }
    let(:jim)     { create(:employee) }
    
    before do
      create(:report, time_in_minutes: 360, reportable: checklist, reportee: john)
      create(:report, time_in_minutes: 240, reportable: checklist, reportee: jim)
    end

    describe '#employee_hours' do
      it 'returns hours worked by employee' do
        expect(Bonus::Fixed.for(project, john).employee_hours).to eq(6)
        expect(Bonus::Fixed.for(project, jim).employee_hours).to eq(4)
      end
    end

    describe '#bonus_percent' do
      it 'returns hours worked by employee' do
        expect(Bonus::Fixed.for(project, john).bonus_percent).to eq(0.6)
        expect(Bonus::Fixed.for(project, jim).bonus_percent).to eq(0.4)
      end
    end

    describe '#bonus_for' do
      it 'returns total salary expenses' do
        expect(Bonus::Fixed.for(project, john).bonus).to eq(2100)
        expect(Bonus::Fixed.for(project, jim).bonus).to eq(1400)
      end
    end

    describe '#total' do
      it 'returns total salary expenses' do
        expect(Bonus::Fixed.for(project, john).total).to eq(2100)
        expect(Bonus::Fixed.for(project, jim).total).to eq(1400)
      end
    end
  end
end
