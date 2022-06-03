class Client < ApplicationRecord
  belongs_to :user
  validates_associated :user
  accepts_nested_attributes_for :user

  delegate :first_name, :last_name, :email, :display_name, :phone, to: :user
end
