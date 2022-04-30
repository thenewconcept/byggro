class ReportPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_worker?
        scope.where(reportee: user.profile)
      elsif user.is_admin?
        scope.all
      end
    end
  end

  def index?
    user.is_worker? or user.is_admin?
  end

  def show?
    user.is_worker? or user.is_admin?
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
