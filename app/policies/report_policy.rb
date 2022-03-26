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
    (record.reportee == user.profile && record.date > 5.days.ago ) || user.is_manager?
  end

  def destroy?
    (record.reportee == user.profile && record.date > 5.days.ago) || user.is_manager?
  end
end
