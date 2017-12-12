class UserServicePolicy < ApplicationPolicy
  def new?
    true
  end
  def create?
    true
  end
  class Scope < Scope
    def resolve
      scope
    end
  end
end
