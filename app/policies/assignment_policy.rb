class AssignmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_manager?
        scope.all
      else
        scope.none
      end
    end
  end

  def new?
    user.is_manager?
  end

  def show?
    user.is_manager?
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
