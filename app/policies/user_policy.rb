class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.is_admin?
  end

  def create?
    user.is_admin?
  end

  def edit?
    user.is_admin? or record === Current.user
  end

  def update?
    user.is_admin? or record === Current.user
  end

  def destroy?
    user.is_admin?
  end

  def switch?
    user.is_admin?
  end
end
