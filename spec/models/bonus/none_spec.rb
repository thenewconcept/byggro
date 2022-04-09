require 'rails_helper'

RSpec.describe Bonus::None, type: :model do
  describe 'a project 10000 budget and 500 hourly rate' do
    let(:project)   { create(:project, bonus: 'none') }
    let(:checklist) { create(:checklist, project: project) }
    
    describe 'with an employee with 200 salary' do
      let!(:employee)  { create(:employee, fee: 200) }
      let!(:contractor)  { create(:contractor, fee: 400) }

      it '#bonus_percent' do
        expect(Bonus::None.for(project, nil).bonus_percent).to eq(0)
      end

      describe '#salary' do
        it 'pays sum of time reported' do
          travel_to Time.parse('1970-01-01')
          employee.update(fee: 100)
          contractor.update(fee: 200)
          travel_back

          create(:report, time_in_hours: 10, reportable: checklist, reportee: employee)
          create(:report, time_in_hours: 10, reportable: checklist, reportee: contractor)

          create(:report, time_in_hours: 10, reportable: checklist, reportee: employee, date: Time.parse('1970-01-02'))
          create(:report, time_in_hours: 10, reportable: checklist, reportee: contractor, date: Time.parse('1970-01-02'))

          expect(Bonus::None.for(project, employee).salary).to eq(3000)
          expect(Bonus::None.for(project, contractor).salary).to eq(6000)
        end
      end
    end
  end
end
