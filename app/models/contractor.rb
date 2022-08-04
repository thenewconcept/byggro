class Contractor < ApplicationRecord
  include Reportee
  has_and_belongs_to_many :projects

  delegate :display_name, to: :user

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