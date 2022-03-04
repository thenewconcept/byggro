class ReportPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.is_worker?
  end

  def update?
    (user.is_worker?  && record.worker == user.worker) || user.is_manager?
  end

  def destroy?
    (user.is_worker?  && record.worker == user.worker) || user.is_manager?
  end
end
