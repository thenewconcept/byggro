class Bonus::Fixed
  attr_reader :project, :reportee, :total_bonus, :total_hours

  def initialize(project, reportee)
    @project   = project
    @reportee  = reportee

    @total_bonus  = project.bonus_fixed
    @total_hours  = project.hours_by_workers
  end

  def self.for(project, reportee)
    new(project, reportee)
  end
  
  def worker_hours
    scope = project.reports.where(reportee_type: ['Employee'])
    scope = scope.where(reportee: reportee) if reportee
    scope.sum(&:time_in_hours)
  end

  def employee_hours
    scope = project.reports.where(reportee_type: 'Employee')
    scope.sum(&:time_in_hours)
  end

  def hours
    scope = project.reports.where(reportee_type: ['Employee'])
    scope = scope.where(reportee: reportee) if reportee
    scope.sum(&:time_in_hours)
  end

  def intern_hours
    scope = project.reports.where(reportee_type: 'Intern')
    scope.sum(&:time_in_hours)
  end

  def bonus_percent
    return 0 if reportee.is_a?(Intern) or reportee.is_a?(Contractor) or (employee_hours.zero?)
    return worker_hours / (total_hours - intern_hours) if reportee
    employee_hours / worker_hours
  end

  def bonus
    bonus_total
  end

  def bonus_total
    total_bonus * bonus_percent
  end

  def total
    return 0 if reportee.is_a?(Intern) or reportee.is_a?(Contractor)
    return bonus_total
  end
end