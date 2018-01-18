class UserPreference < ApplicationRecord
  belongs_to :user

  validates :setting, uniqueness: { scope: :user}
end
