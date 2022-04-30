class ReportPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_worker?
        scope.where(reportee: user.profile)
      elsif user.admin?
        scope.all
      end
    end
  end

  def index?
    user.is_worker?
  end
end
