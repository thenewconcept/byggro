class Employee < ApplicationRecord
  include Reportee

  attr_writer :fee
  alias_attribute :fee, :salary

  validates :user, presence: true, uniqueness: true
  belongs_to :user

  delegate :email, :password, :first_name, :last_name, :full_name, :display_name, to: :user

  def fee=(value)
    write_attribute(:salary, value)
  end
end