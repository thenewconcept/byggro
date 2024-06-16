class Intern < ApplicationRecord
  include Reportee

  def complete?
    true
  end

  def salary; 0; end
  def salary_changed?; false; end

  def fee; 0; end
  def fee_changed?; false; end

  def title
    'Praktikant'
  end
end