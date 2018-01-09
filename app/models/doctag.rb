class Doctag < ApplicationRecord
  belongs_to :document
  belongs_to :tag
  has_one :user, through: :document
end
