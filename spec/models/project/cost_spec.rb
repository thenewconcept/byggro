require 'rails_helper'

RSpec.describe Project::Cost do
  context 'Normal project' do
    let(:normal) { Project::Cost.new( create(:project, bonus: :none) ) }
    let(:john) { create(:employee, salary: 200) }
    let(:jane) { create(:employee, salary: 100) }
    let(:jake) { create(:contractor, fee: 400) }

    before do
      create(:report, time_in_hours: 10, reportable: normal.project, reportee: john)
      create(:report, time_in_hours: 10, reportable: normal.project, reportee: jane)
      create(:report, time_in_hours: 10, reportable: normal.project, reportee: jake)
    end

    describe '#taxes' do
      it 'returns taxes for the project' do
        expect(normal.taxes).to eq(1320.0)
      end
    end

    describe '#salaries' do
      it 'returns the sum of salaries' do
        expect(normal.salaries).to eq(3000)
      end
    end

    describe '#fees' do
      it 'returns the sum of contractor fees' do
        expect(normal.fees).to eq(4000)
      end

      it 'should not include non-payable fees' do
        report = create(:report, time_in_hours: 10, reportable: normal.project, reportee: jake)
        expect(normal.fees).to eq(8000)

        report.update(payable: false)
        expect(normal.fees).to eq(4000)
      end
    end

    describe '#expenses' do
      it 'returns the sum of expenses' do
        create(:expense, amount: 100)
        create(:expense, amount: 100, project: normal.project)
        create(:expense, amount: 250, project: normal.project)
        expect(normal.expenses).to eq(350)
      end  
    end
  end
end