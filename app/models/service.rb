class Service < ApplicationRecord
  has_many :users, through: :user_services
  mount_uploader :logo, PhotoUploader

  def current_user_service(user)
    UserService.where(service_id: self.id, user_id: user.id).first
  end

  # get service name with "_" replaced by whitespaces
  def name_clean
    self.name.gsub(/_/, " ").titleize
  end

end
