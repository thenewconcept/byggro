class User < ApplicationRecord
  has_secure_password

  has_one :worker, dependent: :destroy
  accepts_nested_attributes_for :worker

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }

  def roles
    roles = []
    roles << 'Anställd' if worker.present?
    roles << 'Arbetsledare' if is_manager?
    roles << 'Admin' if is_admin?
    return roles.join(', ')
  end

  def full_name
    [first_name, last_name].compact.join(' ').presence
  end

  def display_name
    return full_name || email
  end

  def is_worker?
    worker.present?
  end

  def is_manager?
    (is_manager || is_admin)
  end
end