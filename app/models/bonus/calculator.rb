class Bonus::Calculator
  attr_reader :project

  def initialize(project)
    @project = project
  end

  def self.for(project)
    new(project)
  end

  def salary_for(reportee)
    Report.by_project(project).where(reportee: reportee).sum(:time_in_minutes).round(2) / 60.0 * reportee.salary
  end

  def bonus_for(reportee)
    _class = eval("Bonus::#{project.bonus.capitalize}")
    _class.for(project, reportee).bonus_amount
  end

  def bonus_total
    public_send("#{project.bonus}_bonus_total")
  end

  def hourly_bonus_total
    Report.by_project(project).reduce(0) do |total, report|
      totalt = total + Bonus::Hourly.for(project, report.reportee).bonus_salary * report.time_in_hours
    end
  end

  def fixed_bonus_total
    project.bonus_fixed
  end
end