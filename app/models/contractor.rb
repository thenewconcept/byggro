class Contractor < ApplicationRecord
  include Reportee

  def complete?
    true
  end

  def salary
    fee
  end

  def title
    'Underentrepenör'
  end
end