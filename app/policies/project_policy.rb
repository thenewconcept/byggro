class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_manager?
        scope.all
      else
        scope
          .not_status_draft
          .includes(:assignments)
          .where(assignments: { user: user })
      end
    end
  end

  def show?
    true
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
