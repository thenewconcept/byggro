class Intern < ApplicationRecord
  include Reportee

  alias_attribute :fee, :salary

  def salary_changed?
    false
  end

  def salary
    0
  end

  def title
    'Praktikant'
  end
end