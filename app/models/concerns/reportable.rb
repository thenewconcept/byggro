module Reportable
  extend ActiveSupport::Concern

  HOURLY_RATE = ENV['HOURLY_RATE']&.to_i || 600

  def workers
    reports.where.not(reportee_type: 'Contractor').map(&:reportee).uniq
  end

  def contractors
    reports.where(reportee_type: 'Contractor').map(&:reportee).uniq
  end

  def reportees
    reports.map(&:reportee).uniq
  end

  def hours_for(reportee)
    reports.where(reportee: reportee).sum(&:time_in_hours)
  end

  def hours_reported
    reports.sum(&:time_in_hours)&.round(2)
  end

  def hours_by_interns
    reports.where(reportee_type: 'Intern').sum(&:time_in_hours)
  end

  def hours_by_workers
    reports.where.not(reportee_type: 'Contractor').sum(&:time_in_hours)
  end

  def hours_by_contractors
    reports.where(reportee_type: 'Contractor').sum(&:time_in_hours)
  end

  def costs_by_workers
    reports.where(reportee_type: 'Employee').sum(&:total)
  end

  def costs_by_contractors
    reports.where(reportee_type: 'Contractor').sum(&:total)
  end
end