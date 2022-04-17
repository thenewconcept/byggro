class PagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_admin? or user.is_manager?
        scope.all
      else
        scope.by_role(user.primary_role)
      end
    end
  end

  def show?
    user
  end

  def create?
    user.is_admin?
  end

  def edit?
    user.is_admin?
  end

  def update?
    user.is_admin?
  end

  def destroy?
    user.is_admin?
  end
end
