class Calculator::None
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
    salary ||= project.reports.where(reportee: reportee).sum do |report|
      report.fee * report.time_in_hours
    end
  end

  def bonus_total
    0
  end

  def salary_total
    salary
  end

  def total; salary_total; end
end