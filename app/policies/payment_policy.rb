class PaymentPolicy < ApplicationPolicy
  def index?
    user.is_worker? or user.is_admin?
  end
end
