class Tag < ApplicationRecord
  has_many :doctags
  has_many :documents, through: :doctags
end
