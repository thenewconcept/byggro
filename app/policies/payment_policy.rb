class PaymentPolicy < ApplicationPolicy
  def index?
    user.is_worker?
  end
end
