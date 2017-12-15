class UserServicePolicy < ApplicationPolicy
  def new?
    true
  end
  def create?
    true
  end
  def destroy?
    record.user == user
  end
  class Scope < Scope
    def resolve
      scope
    end
  end
end
