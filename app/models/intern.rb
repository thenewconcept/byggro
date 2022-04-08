class Intern < ApplicationRecord
  include Reportee

  validates :user, presence: true, uniqueness: true
  belongs_to :user

  alias_attribute :fee, :salary
  delegate :email, :password, :first_name, :last_name, :full_name, :display_name, to: :user

  def salary
    0
  end

  def title
    'Praktikant'
  end
end