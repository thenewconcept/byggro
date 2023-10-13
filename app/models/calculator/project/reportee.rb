module Calculator
  module Project
    class Reportee
      attr_reader :project, :reportee, :total_bonus, :total_hours

      def initialize(project:, reportee:)
        raise ArgumentError, "Project cannot be nil" if project.nil?
        raise ArgumentError, "Reportee cannot be nil" if reportee.nil?
        @reportee     = reportee
        @project      = project

        @base = Base.new(project)
        @total_bonus  = @base.total_bonus
        @total_hours  = @base.total_hours
      end

      def reportee_hours
        @reportee_hours ||= project.reports.where(reportee_type: ['Employee', 'Contractor'], reportee: reportee).sum(&:time_in_hours)
      end

      def payable_bonus_percentage
        @payable_bonus_percent ||= reportee_hours / @base.accountable_hours
      end

      def payable_bonus_amount
        return 0 if reportee.is_a?(Contractor) or reportee.is_a?(Intern)
        project.checklists.sum do |checklist|
          Calculator::Checklist::Reportee.new(checklist: checklist, reportee: reportee).payable_bonus_amount
        end
      end
    end
  end
end