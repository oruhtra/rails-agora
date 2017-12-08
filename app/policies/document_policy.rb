class DocumentPolicy < ApplicationPolicy
  def show?
    record.user ==  user
  end
  def new?
    true
  end
  def create?
    record.user == user
  end
  def update?
    record.user == user
  end
  def destroy?
    record.user == user
  end
  def batch_update?
    true
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
