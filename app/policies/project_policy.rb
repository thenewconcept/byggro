class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_manager?
        scope.all
      elsif user.is_contractor?
        scope.by_contractor(user.contractor)
      else
        scope.not_status_draft
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

  def administer?
    user.is_admin?
  end

  def complete?
    user.is_admin? or !record.status_completed?
  end
  
  def report?
    user.is_worker? and !record.status_completed?
  end

  def checklist?
    create? and !record.status_completed?
  end

  def todo?
    checklist?
  end

  def meta?
    user.is_employee? or user.is_manager?
  end

  def salary?
    user.is_employee? and record.try(:status_completed?)
  end
end
