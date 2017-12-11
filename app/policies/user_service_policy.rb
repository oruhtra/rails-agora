class UserServicePolicy < ApplicationPolicy
  def new?
    true
  end
  class Scope < Scope
    def resolve
      scope
    end
  end
end
