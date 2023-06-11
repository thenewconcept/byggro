module Calculator
  module Checklist
    class Base
      attr_reader :reportable, :total_bonus, :total_hours

      def initialize(reportable)
        raise ArgumentError, "Checklist cannot be nil" if reportable.nil?
        @reportable   = reportable
        @total_bonus  = reportable.bonus_fixed
        @total_hours  = reportable.hours_reported
      end

      def accountable_hours
        scope = reportable.reports.where(reportee_type: ['Employee', 'Contractor'])
        scope.sum(&:time_in_hours)
      end

      def payable_hours
        scope = reportable.reports.where(reportee_type: ['Employee'])
        scope.sum(&:time_in_hours)
      end

      def payable_bonus_percentage
        @bonus_percent ||= payable_hours / accountable_hours
      end

      def payable_bonus_amount
        return 0 if reportable.hours_reported.zero?
        total_bonus * payable_bonus_percentage
      end
    end
  end
end