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
    Report.by_project(project).where(reportee: reportee).sum(&:time_in_hours)
  end

  def intern_hours
    Report.by_project(project).where(reportee_type: 'Intern').sum(&:time_in_hours)
  end

  def bonus_percent
    return 0 if reportee.is_a?(Intern)
    bonus_percent = worker_hours / (total_hours - intern_hours)
  end

  def bonus_total
    project.bonus_fixed
  end

  def bonus
    return 0 if reportee.is_a?(Contractor)
    total_bonus * bonus_percent
  end

  def total; bonus; end

  def salary
    return worker_hours * reportee.salary if reportee.is_a?(Contractor)
    total
  end
end