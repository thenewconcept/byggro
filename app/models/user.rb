class User < ApplicationRecord
  has_secure_password

  has_one :worker, dependent: :destroy
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }

  def is_worker?
    worker.present?
  end

  def is_manager?
    (is_manager || is_admin)
  end
end