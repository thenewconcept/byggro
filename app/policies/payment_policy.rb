class PaymentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_admin?
        scope.all
      end
    end
  end

  def index?
    user.is_manager?
  end

  def create?
    user.is_admin?
  end

  def destroy?
    user.is_admin?
  end
end
