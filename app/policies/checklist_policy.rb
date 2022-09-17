class ChecklistPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.is_manager?
  end

  def update?
    user.is_manager?
  end

  def destroy?
    user.is_manager?
  end

  def meta?
    true
  end
  
  def salary?
    user.is_employee? and 
      record.project.try(:status_completed?) and
      record.project.try(:bonus_fixed?)
  end
end
