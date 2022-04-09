class Employee < ApplicationRecord
  include Reportee

  attr_writer :fee
  alias_attribute :fee, :salary

  def fee=(value)
    write_attribute(:salary, value)
  end
end