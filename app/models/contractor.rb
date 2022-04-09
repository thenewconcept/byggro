class Contractor < ApplicationRecord
  include Reportee

  def salary
    fee
  end

  def title
    'Underentrepenör'
  end
end