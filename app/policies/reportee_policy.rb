class ReporteePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
