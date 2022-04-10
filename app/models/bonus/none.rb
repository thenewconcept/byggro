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
    salary ||= Report.by_project(project).where(reportee: reportee).reduce(0) do |salary, report|
      salary += report.fee * report.time_in_hours
    end
  end

  def salary_total
    salary
  end

  def total; salary_total; end
end