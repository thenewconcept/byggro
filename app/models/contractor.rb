class Contractor < ApplicationRecord
  include Reportee

  validates :user, presence: true, uniqueness: true
  belongs_to :user

  delegate :email, :password, :first_name, :last_name, :full_name, :display_name, to: :user

  def salary
    fee
  end

  def title
    'Underentrepenör'
  end
end