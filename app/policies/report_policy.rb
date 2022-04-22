class ReportPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.is_admin?
  end

  def show?
    user.is_worker?
  end

  def create?
    user.is_worker? && !record.reportable.status_completed?
  end

  def update?
    (record.reportee == user.profile && record.date > 5.days.ago ) || user.is_manager?
  end

  def destroy?
    (record.reportee == user.profile && record.date > 5.days.ago) || user.is_manager?
  end
end
