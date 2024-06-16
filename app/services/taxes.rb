module Taxes
  VAT = 0.25
  EMPLOYER_TAX = 0.3142
  VACATION_TAX = 0.125

  def add_taxes(amount, taxes)
    (amount.to_d * (1.0.to_d + self.class.const_get(taxes.to_s.upcase).to_d)).to_f
  end

  def get_taxes(amount, *taxes)
    taxes.reduce(0) do |sum, tax|
      sum.to_d + (amount.to_d * self.class.const_get(tax.to_s.upcase).to_d)
    end.to_f
  end
end