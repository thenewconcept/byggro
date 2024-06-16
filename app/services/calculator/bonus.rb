module Calculator
  class Bonus
    include Taxes

    def initialize(reportable)
      @reportable = reportable
    end

    def excluding_taxes
      if @reportable.is_a?(Project)
        @reportable.checklists.payout_fixed.sum(&:amount)
      elsif @reportable.is_a?(Checklist)
        @reportable.amount
      end
    end

    def taxes
      @taxes ||= get_taxes(excluding_taxes, :vacation_tax, :employer_tax)
    end

    def including_taxes
      @including_taxes ||= excluding_taxes + taxes
    end
  end
end