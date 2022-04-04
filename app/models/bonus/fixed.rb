class Bonus::Fixed
  BASE = ENV['FIXED_BASE']&.to_f || 0.35
  attr_reader :project, :reportee, :total_bonus, :total_hours

  def initialize(project, reportee)
    @project = project
    @reportee  = reportee

    @total_bonus  = project.bonus_fixed
    @total_hours  = project.hours_reported
  end

  def self.for(project, reportee)
    new(project, reportee)
  end
  
  def employee_hours
    Report.by_project(project).where(reportee: reportee).sum(:time_in_minutes).to_f / 60
  end

  def employee_percentage
    employee_percentage = employee_hours / total_hours
  end

  def bonus_amount
    total_bonus * employee_percentage
  end
end