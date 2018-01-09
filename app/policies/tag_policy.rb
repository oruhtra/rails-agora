class TagPolicy < ApplicationPolicy
  def create?
    true
  end
  class Scope < Scope
    def resolve
      scope.where(user_id: [nil, user.id])
    end
  end
end
