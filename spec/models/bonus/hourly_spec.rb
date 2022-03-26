require 'rails_helper'

RSpec.describe Bonus::Hourly, type: :model do
  describe 'a project 10000 budget and 500 hourly rate' do
    let(:project)   { create(:project, hourly_rate: 500) }
    let(:checklist) { create(:checklist, amount: 10000, project: project) }

    describe 'with an employee with 200 salary' do
      let(:worker)  { create(:worker, salary: 200) }
      let(:calc)    { Bonus::Hourly.for(project, worker) }

      it '#bonus_base' do
        expect(calc.bonus_base).to eq(100)
      end

      it 'pays 50 when done in 50% time' do
        create(:report, time_in_minutes: 600, reportable: checklist)
        expect(calc.bonus_salary).to eq(50)
      end

      it 'pays 25 when done in 75% time' do
        create(:report, time_in_minutes: 900, reportable: checklist)
        expect(calc.bonus_salary).to eq(25)
      end
    end

    describe 'with an employee with 100 salary' do
      let(:worker)  { create(:worker, salary: 100) }
      let(:calc)    { Bonus::Hourly.for(project, worker) }

      it '#bonus_base' do
        expect(calc.bonus_base).to eq(200)
      end

      describe '#bonus_salary' do
        it 'pays 100 when done in 50% time' do
          create(:report, time_in_minutes: 600, reportable: checklist)
          expect(calc.bonus_salary).to eq(100)
        end

        it 'pays 50 when done in 75% time' do
          create(:report, time_in_minutes: 900, reportable: checklist)
          expect(calc.bonus_salary).to eq(50)
        end
      end
    end

    describe '#bonus_total' do
      let(:john)    { create(:worker, salary: 200) }
      let(:jim)     { create(:worker, salary: 100) }

      it 'returns total salary expenses' do
        create(:report, time_in_minutes: 300, reportable: checklist, reportee: john)
        create(:report, time_in_minutes: 300, reportable: checklist, reportee: jim)

        expect(Bonus::Hourly.for(project, john).bonus_total).to eq(250)
        expect(Bonus::Hourly.for(project, jim).bonus_total).to eq(500)
      end
    end
  end
end
