class Intern < ApplicationRecord
  include Reportee

  alias_attribute :fee, :salary

  def salary
    0
  end

  def title
    'Praktikant'
  end
end