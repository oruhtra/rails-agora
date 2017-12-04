class Document < ApplicationRecord
  belongs_to :user
  has_many :doctags
  has_many :tags, through: :doctags
end
