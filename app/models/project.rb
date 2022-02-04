class Project < ApplicationRecord
  def total
    [work_amount, material_amount, misc_amount].sum
  end

  def salaries
    work_amount * 0.35
  end

  def expenses
    material_amount * 0.20
  end
end
