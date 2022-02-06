class TodoPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.is_manager?
  end

  def edit?
    user
  end

  def update?
    user
  end

  def destroy?
    user.is_manager?
  end
end
