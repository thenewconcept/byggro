class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_manager?
        scope.all
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
    !user.is_contractor? && !user.is_intern?
  end

  def salary?
    user.is_employee? and 
      record.try(:status_completed?) and
      record.try(:bonus_fixed?)
  end
end
