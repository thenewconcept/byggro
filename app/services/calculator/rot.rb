module Calculator
  class Rot
    include Taxes

    attr_reader :reportable

    def initialize(reportable)
      @reportable = reportable
    end

    def hours
      if reportable.is_a?(Checklist) and reportable.payout_fixed?
        hours_for_fixed
      elsif reportable.is_a?(Checklist) and reportable.payout_hourly?
        hours_for_hourly
      else
        reportable.checklists.sum(&:hours_reported)
      end
    end

    private

    def hours_for_hourly
      Report.by_checklist(reportable).sum(&:time_in_hours)
    end

    def hours_for_fixed
      reportable.amount / Project::HOURLY_RATE
    end
  end
end