class Project < ApplicationRecord
  after_save :generate_checklists

  has_rich_text :description
  has_many :checklists, dependent: :destroy
  has_many :todos, through: :checklist

  def total
    [work_amount, material_amount, misc_amount].sum
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
    work_amount / 500
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
