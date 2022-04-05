class Bonus::None
  attr_reader :project, :reportee

  def initialize(project, reportee)
    @project  = project
    @reportee = reportee
  end

  def self.for(project, reportee)
    new(project, reportee)
  end

  def bonus_percent; 0; end 

  def salary
    reportee.salary * (Report.by_project(project).where(reportee: reportee).sum(&:time_in_hours))
  end

  def salary_total
    salary
  end
end