class ClientPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.is_admin?
        scope.all
      end
    end
  end

  def show?
    user.is_manager?
  end

  def index?
    user.is_manager?
  end

  def create?
    user.is_manager?
  end

  def edit?
    user.is_manager?
  end

  def update?
    user.is_manager?
  end

  def destroy?
    user.is_manager?
  end
end
