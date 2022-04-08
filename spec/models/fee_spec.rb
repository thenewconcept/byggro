require 'rails_helper'

RSpec.describe Fee, type: :model do
  describe "#by_date" do
    it 'returns the Reportee fee at a date' do
      travel_to Time.parse('2020-01-01')
      employee = create(:employee, salary: 100)

      travel_to Time.parse('2021-01-01')
      employee.update_attribute(:salary, 200)

      travel_to Time.parse('2022-01-01')
      employee.update_attribute(:salary, 300)

      expect(employee.fees.at_date('2020-02-01').amount).to eq(100)
      expect(employee.fees.at_date('2021-02-01').amount).to eq(200)
      expect(employee.fees.at_date('2023-02-01').amount).to eq(300)
    end
  end

  it 'saves Reportee fee when changed' do
    employee = create(:employee, fee: 100)
    expect(Fee.count).to eq(1)
    expect(Fee.first.reportee).to eq(employee)

    employee.update_attribute(:title, 'Manager')
    expect(Fee.count).to eq(1)

    employee.update_attribute(:salary, 200)
    expect(Fee.count).to eq(2)
    expect(Fee.last.amount).to eq(employee.fee)
  end

end
