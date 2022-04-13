class PagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_admin? or user.is_manager?
        scope.all
      else
        scope.by_role(user.profile.to_s)
    end
  end

  def show?
    true
  end

  def create?
    user.is_admin?
  end

  def edit?
    user.is_admin?
  end
  end

  def update?
    user.is_admin?
  end

  def destroy?
    user.is_admin?
  end
end
