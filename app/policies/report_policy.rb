class ReportPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.is_worker? || user.is_contractor?
  end

  def update?
    (record.reportee == user.profile) || user.is_manager?
  end

  def destroy?
    (record.reportee == user.profile) || user.is_manager?
  end
end
