class DoctagPolicy < ApplicationPolicy
  def create?
    record.document.user == user
  end
  def destroy?
    record.document.user == user
  end
  class Scope < Scope
    def resolve
      scope
    end
  end
end
