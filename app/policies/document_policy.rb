class DocumentPolicy < ApplicationPolicy
  def create?
    record.user == user
  end
  def new?
    true
  end
  def show?
    record.user ==  user
  end
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
