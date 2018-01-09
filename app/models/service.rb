class Service < ApplicationRecord
  has_many :users, through: :user_services

  def current_user_service(user)
    UserService.where(service_id: self.id, user_id: user.id).first
  end
end
