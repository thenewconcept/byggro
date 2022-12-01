class Bonus::Fixed
  attr_reader :project, :reportee, :total_bonus, :total_hours

  def initialize(project, reportee)
    @project   = project
    @reportee  = reportee

    @total_bonus  = project.bonus_fixed
    @total_hours  = project.hours_reported
  end

  def self.for(project, reportee)
    new(project, reportee)
  end
  
  def worker_hours
    scope = project.reports.where(reportee_type: ['Employee', 'Contractor'])
    scope = scope.where(reportee: reportee) if reportee
    scope.sum(&:time_in_hours)
  end

  def employee_hours
    scope = project.reports.where(reportee_type: 'Employee')
    scope.sum(&:time_in_hours)
  end

  def hours
    scope = project.reports.where(reportee_type: ['Employee', 'Contractor'])
    scope = scope.where(reportee: reportee) if reportee
    scope.sum(&:time_in_hours)
  end

  def intern_hours
    scope = project.reports.where(reportee_type: 'Intern')
    scope.sum(&:time_in_hours)
  end

  def contractor_hours
    scope = project.reports.where(reportee_type: 'Contractor')
    scope.sum(&:time_in_hours)
  end

  def bonus_percent
    return 0 if reportee.is_a?(Intern) or (employee_hours.zero?)
    return worker_hours / (total_hours - intern_hours) if reportee
    employee_hours / worker_hours
  end

  def bonus
    bonus_total
  end

  def bonus_total
    return 0 if reportee.is_a?(Contractor)
    total_bonus * bonus_percent
  end

  def total
    return 0 if reportee.is_a?(Intern)
    return bonus_total if reportee.is_a?(Employee)
    return salary if reportee.is_a?(Contractor)
    bonus_total + salary
  end

  def salary
    scope = project.reports.where(reportee_type: 'Contractor')
    scope = scope.where(reportee: reportee) if reportee
    scope.sum(&:total)
  end
end