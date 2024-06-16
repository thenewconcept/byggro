require 'rails_helper'

class Invoice; include Taxes; end
class Salary; include Taxes; end

RSpec.describe Taxes do
  before do
    stub_const("Taxes::VAT", 0.1)
    stub_const("Taxes::EMPLOYER_TAX", 0.2)
    stub_const("Taxes::VACATION_TAX", 0.5)
  end

  describe "constants" do
    it 'are accessible' do
      expect(Invoice::VAT).to eq(0.1)
      expect(Salary::EMPLOYER_TAX).to eq(0.2)
      expect(Salary::VACATION_TAX).to eq(0.5)
    end
  end

  describe "#add_taxes" do
    it 'returns the amount including VAT' do
      invoice = Invoice.new
      expect(invoice.add_taxes(100, :vat)).to eq(110)
    end

    it 'returns the amount including EMPLOYER_TAX' do
      salary = Salary.new
      expect(salary.add_taxes(100, :employer_tax)).to eq(120)
    end

    it 'returns the amount including VACATION_TAX' do
      salary = Salary.new
      expect(salary.add_taxes(100, :vacation_tax)).to eq(150)
    end
  end

  describe "#get_taxes" do
    it "returns the sum of given taxes to the amount" do
      salary = Salary.new

      result = salary.get_taxes(1000, :vacation_tax, :employer_tax)

      expect(result).to eq(700)
    end
  end
end