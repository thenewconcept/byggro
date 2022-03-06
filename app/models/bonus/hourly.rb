class Bonus::Hourly
  BASE = ENV['HOURLY_BASE']&.to_i || 300
  attr_reader :project, :worker

  def initialize(project, worker)
    @project = project
    @worker = worker
  end

  def self.for(project, worker)
    new(project, worker)
  end
  
  def bonus_base
    Bonus::Hourly::BASE - worker.salary 
  end

  def bonus_salary
    bonus_base * (1.0 - project.hourly_percent).round(2)
  end

  def bonus_total
    bonus_salary * (project.reports.where(worker: worker).sum(:time_in_minutes) / 60)
  end
end