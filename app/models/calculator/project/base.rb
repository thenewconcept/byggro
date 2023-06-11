module Calculator
  module Project
    class Base
      attr_reader :project, :total_bonus, :total_hours

      def initialize(project)
        raise ArgumentError, "Project cannot be nil" if project.nil?
        
        @project      = project
        @total_bonus  = project.bonus_fixed
        @total_hours  = project.hours_reported
      end

      def accountable_hours
        scope = project.reports.where(reportee_type: ['Employee', 'Contractor'])
        scope.sum(&:time_in_hours)
      end

      def payable_hours
        scope = project.reports.where(reportee_type: ['Employee'])
        scope.sum(&:time_in_hours)
      end

      def payable_bonus_percentage
        @bonus_percent ||= payable_hours / accountable_hours
      end

      def payable_bonus_amount
        project.checklists.sum do |c|
          Calculator::Checklist::Base.new(c).payable_bonus_amount
        end
      end
    end
  end
end