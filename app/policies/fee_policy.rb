class FeePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  def index?
    user.is_admin?
  end

  def show?
    user.is_admin?
  end
end
