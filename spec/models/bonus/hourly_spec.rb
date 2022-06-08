require 'rails_helper'

RSpec.describe Bonus::Hourly, type: :model do
  describe 'a project 10000 budget and 500 hourly rate' do
    let(:project)   { create(:project, hourly_rate: 500) }
    let(:checklist) { create(:checklist, amount: 10000, project: project) }
    
    let(:project2)   { create(:project, hourly_rate: 500) }
    let(:checklist2) { create(:checklist, amount: 10000, project: project2) }

    describe 'with an employee with 200 salary' do
      let(:employee)  { create(:employee, salary: 200) }
      let(:calc)    { Bonus::Hourly.for(project, employee) }

      describe '#bonus_base(salary)' do
        it 'calculates the bonusbase for a given salary and INDEX' do
          stub_const('Bonus::Hourly::BONUS_INDEX', 300)
          expect(calc.bonus_base(100)).to eq(100)
          expect(calc.bonus_base(160)).to eq(140)
          expect(calc.bonus_base(200)).to eq(100)

          stub_const('Bonus::Hourly::BONUS_INDEX', 280)
          expect(calc.bonus_base(100)).to eq(100)
          expect(calc.bonus_base(160)).to eq(120)
          expect(calc.bonus_base(200)).to eq(80)
        end
      end

      it 'pays 100 when done in 50% time' do
        create(:report, time_in_hours: 10, reportable: checklist)
        stub_const('Bonus::Hourly::BONUS_INDEX', 300)
        expect(calc.bonus_salary(200)).to eq(50)
      end

      it 'pays 25 when done in 75% time' do
        stub_const('Bonus::Hourly::BONUS_INDEX', 300)
        create(:report, time_in_hours: 15, reportable: checklist)
        expect(calc.bonus_salary(200)).to eq(25)
      end
    end

    describe 'with an employee with 100 salary' do
      let(:employee) { create(:employee, salary: 100) }
      let(:calc)     { Bonus::Hourly.for(project, employee) }

      describe '#salary' do
        it 'pays base salary of 1000' do
          create(:report, time_in_hours: 10, reportee: employee, reportable: checklist)
          expect(calc.salary).to eq(1000)
        end

        it 'pays base salary of 1500' do
          create(:report, time_in_hours: 15, reportee: employee, reportable: checklist)
          expect(calc.salary).to eq(1500)
        end
      end

      it '#bonus_base' do
        stub_const('Bonus::Hourly::BONUS_INDEX', 300)
        expect(calc.bonus_base(100)).to eq(100)

        stub_const('Bonus::Hourly::BONUS_INDEX', 150)
        expect(calc.bonus_base(100)).to eq(50)
      end

      describe '#bonus_salary' do
        it 'pays 50 when done in 50% time' do
          stub_const('Bonus::Hourly::BONUS_INDEX', 300)
          create(:report, time_in_hours: 10, reportable: checklist)
          expect(calc.bonus_salary(100)).to eq(50)
        end

        it 'pays 25 when done in 75% time' do
          stub_const('Bonus::Hourly::BONUS_INDEX', 300)
          create(:report, time_in_hours: 15, reportable: checklist)
          expect(calc.bonus_salary(100)).to eq(25)
        end
      end
    end

    describe 'no bonus' do
      it 'returns 0 and not negative values' do
        stub_const('Bonus::Hourly::BONUS_INDEX', 300)
        # 1 hour project.
        overdrawn = create(:project, hourly_rate: 500)
        overdrawn.checklists.first.update(amount: 500)

        jill = create(:employee, salary: 200)
        report = create(:report, time_in_hours: 2, reportable: overdrawn.checklists.first)

        nobonus = Bonus::Hourly.for(overdrawn, jill)
        expect(nobonus.bonus_salary(jill.salary)).to eq(0)
        expect(nobonus.bonus_for_report(report)).to eq(0)
      end
    end

    describe '#bonus' do
      let(:john)    { create(:employee, salary: 200) }
      let(:jim)     { create(:employee, salary: 100) }

      it 'returns total bonus for reportee' do
        stub_const('Bonus::Hourly::BONUS_INDEX', 300)
        create(:report, time_in_hours: 5, reportable: checklist, reportee: john)
        create(:report, time_in_hours: 10, reportable: checklist, reportee: jim)

        expect(Bonus::Hourly.for(project, john).bonus).to eq(125)
        expect(Bonus::Hourly.for(project, jim).bonus).to eq(250)
      end

      it 'cannot be negative' do
        stub_const('Bonus::Hourly::BONUS_INDEX', 300)
        create(:report, time_in_hours: 40, reportable: checklist, reportee: john)
        expect(Bonus::Hourly.for(project, john).bonus).to eq(0)
      end
    end

    describe '#total' do
      let(:john)    { create(:employee, salary: 200) }
      let(:jim)     { create(:employee, salary: 100) }
      let(:jake)     { create(:contractor, fee: 500) }
      let(:jill)     { create(:intern) }

      before do
        stub_const('Bonus::Hourly::BONUS_INDEX', 300)

        # Estimated hours 20h. Actual worked hours 16h. Bonus is 20%.
        create(:report, time_in_hours: 4, reportable: checklist, reportee: john)
        create(:report, time_in_hours: 4, reportable: checklist, reportee: jim)
        create(:report, time_in_hours: 4, reportable: checklist, reportee: jill)
        create(:report, time_in_hours: 4, reportable: checklist, reportee: jake)

        create(:report, time_in_hours: 5, reportable: checklist2, reportee: jim)
      end

      it 'returns total bonus for project' do
        # 5h x 0 = 0.
        expect(Bonus::Hourly.for(project, jill).total).to eq(0)

        # (S: 4h x 200 = 800) + (B: 100 * 0.20 * 4 = 80) = 880 kr
        expect(Bonus::Hourly.for(project, john).total).to eq(880)

        # (S: 4h x 100 = 400) + (B: 100 * 0.20 * 4 = 80) = 480 kr
        expect(Bonus::Hourly.for(project, jim).total).to eq(480)

        # Jake is contractor, so fast fee.
        expect(Bonus::Hourly.for(project, jake).total).to eq(2000)
      end

      it 'returns the total salaries for the project' do
        expect(Bonus::Hourly.for(project, nil).total).to eq(3360)
      end
    end
  end
end
