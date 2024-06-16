module Bonusable
  # expects and amount, hourly_rate and reportable
  extend ActiveSupport::Concern

  def hours_target
    return 0 if amount.zero? or hourly_rate.zero?
    amount / hourly_rate
  end

  def payout_fixed
    ((amount - costs_by_contractors) * fixed_fee).round(0)
  end

  def bonus_percent
    (1 - hourly_percent)
  end

  def hourly_percent
    return 0 if hours_reported.zero? or hours_target.zero?
    hours_reported / hours_target
  end

  def bonus_salary_hourly(salary, hours)
    salary * bonus_percent
  end

  def bonus_salary_total(salary, hours)
    hours * bonus_salary_hourly(salary, hours)
  end

  def actual_salary_hourly(salary, hours)
    [salary + bonus_salary_hourly(salary, hours), salary].max
  end

  def actual_salary_total(salary, hours)
    hours * actual_salary_hourly(salary, hours)
  end
end