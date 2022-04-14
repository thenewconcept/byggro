class Employee < ApplicationRecord
  include Reportee

  attr_writer :fee
  alias_attribute :fee, :salary

  def complete?
    pid.present? && bank.present? && salary.present? && account.present?
  end

  def fee=(value)
    write_attribute(:salary, value)
  end
end