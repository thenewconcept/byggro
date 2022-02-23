class Project < ApplicationRecord
  BASESALARY = 180
  BASEHOUR = 500
  validates :work_amount, :material_amount, :misc_amount, numericality: true

  after_create :generate_checklists

  has_rich_text :description
  has_many :checklists, dependent: :destroy
  has_many :todos, through: :checklist

  def target
    hours * BASESALARY
  end

  def total
    [work_amount, material_amount, misc_amount].sum
  end

  def hourly_salary(_hours)
    BASESALARY * ( 1+bonus_percent(_hours) )
  end

  def bonus_percent(actual_hours)
    1 - (actual_hours / hours)
  end

  def bonus_amount(_hours)
    target * bonus_percent(_hours)
  end

  def base_salary(hours)
    hours * Project::BASESALARY
  end

  def salaries
    work_amount * 0.35
  end

  def expenses
    material_amount * 0.20
  end

  def rot
    inc_vat(work_amount) * 0.3
  end

  def hours
    work_amount / BASEHOUR
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
