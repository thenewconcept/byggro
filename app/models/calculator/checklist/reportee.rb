module Calculator
  module Checklist
    class Reportee
      attr_reader :checklist, :reportee, :total_bonus, :total_hours

      def initialize(checklist:, reportee:)
        raise ArgumentError, "Checklist cannot be nil" if checklist.nil?
        raise ArgumentError, "Reportee cannot be nil" if reportee.nil?
        @reportee     = reportee
        @checklist    = checklist

        @base = Base.new(checklist)
        @total_bonus  = @base.total_bonus
        @total_hours  = @base.total_hours
      end

      def reportee_hours
        @reportee_hours ||= checklist.reports.where(reportee_type: ['Employee', 'Contractor'], reportee: reportee).sum(&:time_in_hours)
      end

      def payable_bonus_percentage
        return 0 if reportee.is_a?(Contractor) or reportee.is_a?(Intern) or total_hours == 0
        @payable_bonus_percent ||= reportee_hours / @base.accountable_hours
      end

      def payable_bonus_amount
        return 0 if reportee.is_a?(Contractor) or reportee.is_a?(Intern)
        total_bonus * payable_bonus_percentage
      end
    end
  end
end