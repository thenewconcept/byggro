class ReportPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    user.is_worker?
  end

  def create?
    user.is_worker?
  end

  def update?
    (record.reportee == user.profile && record.date > 5.days.ago ) || user.is_manager?
  end

  def destroy?
    (record.reportee == user.profile && record.date > 5.days.ago) || user.is_manager?
  end
end
