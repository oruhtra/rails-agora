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
    record.user == user
  end
  def batch_create_tag?
    record.user == user
  end
  def download?
    record.user == user
  end

  def selected_doc?
    true
  end

  def scrap_documents?
    record.user == user
  end

  def add_tags?
    record.user == user
  end

  def load_new_elements?
    record.user == user
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
