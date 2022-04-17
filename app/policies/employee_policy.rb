class EmployeePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    (record.user == user and !record.complete?) or user.is_admin?
  end
end
