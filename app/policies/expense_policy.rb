class ExpensePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_manager?
        scope.all
      elsif user.is_worker?
        scope.where(user: user)
      end
    end
  end

  def administer?
    user.is_manager?
  end

  def index?
    user.is_employee? or user.is_manager?
  end

  def create?
    true
  end

  def update?
    record.user == user or user.is_manager?
  end

  def destroy?
    user.is_admin?
  end
end
