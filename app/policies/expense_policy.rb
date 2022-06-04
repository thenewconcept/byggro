class ExpensePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def administer?
    user.is_manager?
  end

  def create?
    user.is_employee? or user.is_manager?
  end

  def update?
    record.user == user or user.is_manager?
  end

  def destroy?
    user.is_admin?
  end
end
