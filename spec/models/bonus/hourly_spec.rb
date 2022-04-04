require 'rails_helper'

RSpec.describe Bonus::Hourly, type: :model do
  describe 'a project 10000 budget and 500 hourly rate' do
    let(:project)   { create(:project, hourly_rate: 500) }
    let(:checklist) { create(:checklist, amount: 10000, project: project) }

    describe 'with an employee with 200 salary' do
      let(:employee)  { create(:employee, salary: 200) }
      let(:calc)    { Bonus::Hourly.for(project, employee) }

      it '#bonus_base' do
        expect(calc.bonus_base).to eq(200)
      end

      it 'pays 100 when done in 50% time' do
        create(:report, time_in_hours: 10, reportable: checklist)
        expect(calc.bonus_salary).to eq(100)
      end

      it 'pays 50 when done in 75% time' do
        create(:report, time_in_hours: 15, reportable: checklist)
        expect(calc.bonus_salary).to eq(50)
      end
    end

    describe 'with an employee with 100 salary' do
      let(:employee)  { create(:employee, salary: 100) }
      let(:calc)    { Bonus::Hourly.for(project, employee) }

      it '#bonus_base' do
        expect(calc.bonus_base).to eq(100)
      end

      describe '#bonus_salary' do
        it 'pays 50 when done in 50% time' do
          create(:report, time_in_hours: 10, reportable: checklist)
          expect(calc.bonus_salary).to eq(50)
        end

        it 'pays 25 when done in 75% time' do
          create(:report, time_in_hours: 15, reportable: checklist)
          expect(calc.bonus_salary).to eq(25)
        end
      end
    end

    describe '#bonus_amount' do
      let(:john)    { create(:employee, salary: 200) }
      let(:jim)     { create(:employee, salary: 100) }

      it 'returns total bonus for project' do
        create(:report, time_in_hours: 5, reportable: checklist, reportee: john)
        create(:report, time_in_hours: 5, reportable: checklist, reportee: jim)

        expect(Bonus::Hourly.for(project, john).bonus_amount).to eq(500)
        expect(Bonus::Hourly.for(project, jim).bonus_amount).to eq(250)
      end
    end

    describe '#bonus_total' do
      let(:john)    { create(:employee, salary: 200) }
      let(:jim)     { create(:employee, salary: 100) }

      it 'returns total bonus for project' do
        create(:report, time_in_hours: 5, reportable: checklist, reportee: john)
        create(:report, time_in_hours: 5, reportable: checklist, reportee: jim)

        expect(Bonus::Hourly.for(project, john).bonus_total).to eq(2500)
        expect(Bonus::Hourly.for(project, jim).bonus_total).to eq(1250)
      end
    end
  end
end
