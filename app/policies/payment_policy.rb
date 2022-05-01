class PaymentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.is_worker? or user.is_admin?
  end
end
