class NotePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    true
  end

  def edit?
    user.is_manager? or record.user == user
  end

  def update?
    user.is_manager? or record.user == user
  end

  def destroy?
    user.is_manager? or record.user == user
  end
end
