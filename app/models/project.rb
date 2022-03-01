class Project < ApplicationRecord
  BASEHOUR = 500

  enum bonus: [ :none, :hourly, :fixed ], _prefix: true
  validates :work_amount, :material_amount, :misc_amount, numericality: true

  after_create :generate_checklists

  has_rich_text :description

  has_many :checklists, dependent: :destroy
  has_many :todos, through: :checklist

  def estimated_hours
    work_amount / BASEHOUR
  end

  def fixed_salaries
    work_amount * 0.35
  end

  def estimated_salaries
    estimated_hours * 160 * 1.33
  end

  def reported_salaries
    reported_hours * 160 * 1.33
  end

  def bonus_percent(hours)
    1 - (hours / estimated_hours)
  end

  def bonus_salary_hourly(salary, hours)
    salary * bonus_percent(hours)
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

  def total
    [work_amount, material_amount, misc_amount].sum
  end

  def expenses
    material_amount * 0.20
  end

  def rot
    inc_vat(work_amount) * 0.3
  end


  def client_costs
    client_payed + rot
  end

  def client_payed
    inc_vat(total) - rot - inc_vat(material_amount)
  end

  def vat(amount)
    amount * 0.25
  end

  def inc_vat(amount)
    amount + vat(amount)
  end

  private
  def generate_checklists
    self.checklists.create(title: 'Arbetsorder')
    self.checklists.create(title: 'ÄTA')
  end
end
