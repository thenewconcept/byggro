module Calculator
  class Salary
    include Taxes

    def initialize(reportable, employee: nil)
      @reportable = reportable
    end

    def excluding_taxes
      @excluding_taxes ||= @reportable.checklists.payout_hourly.sum(&:salary)
    end

    def taxes
      @taxes ||= get_taxes(excluding_taxes, :vacation_tax, :employer_tax)
    end

    def including_taxes
      @including_taxes ||= excluding_taxes + taxes
    end
  end
end