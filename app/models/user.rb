class User < ApplicationRecord
  has_secure_password
  
  before_create { self.email = email.downcase }

  has_one :contractor, dependent: :destroy
  has_one :employee, dependent: :destroy
  has_one :intern, dependent: :destroy

  has_many :assignments
  has_many :projects, through: :assignments

  accepts_nested_attributes_for :employee
  accepts_nested_attributes_for :contractor

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }

  def roles
    roles = []
    roles << 'Praktikant' if intern.present?
    roles << 'Anställd'   if employee.present?
    roles << 'Underentrepenör' if contractor.present?
    roles << 'Arbetsledare' if is_manager?
    roles << 'Admin' if is_admin?
    return roles.join(', ')
  end

  def profile
    return employee if is_employee?
    return intern if is_intern?
    return contractor if is_contractor?
  end

  def full_name
    [first_name, last_name].compact.join(' ').presence
  end

  def display_name
    (full_name || email)
  end

  def is_worker?
    is_contractor? || is_employee?
  end

  def is_contractor?
    contractor.present?
  end

  def is_employee?
    employee.present?
  end

  def is_intern?
    intern.present?
  end

  def is_manager?
    (is_manager || is_admin)
  end
end