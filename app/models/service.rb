class Service < ApplicationRecord
  has_many :users, through: :user_services
end
