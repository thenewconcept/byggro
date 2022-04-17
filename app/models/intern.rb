class Intern < ApplicationRecord
  include Reportee

  alias_attribute :fee, :salary

  def complete?
    true
  end

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