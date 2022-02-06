class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.is_manager?
  end

  def update?
    user.is_manager?
  end

  def destroy?
    user.is_admin?
  end
end
