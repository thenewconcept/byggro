module Bonusable
  # expects and amount, hourly_rate
  extend ActiveSupport::Concern

  def hours_target
    amount / hourly_rate
  end

  def reported_salaries
    hours_reported * 160
  end

  def bonus_fixed
    amount * 0.35
  end

  def estimated_salaries
    hours_target * 160
  end

  def bonus_percent
    (1 - hourly_percent)
  end

  def hourly_percent
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