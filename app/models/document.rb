class Document < ApplicationRecord
  belongs_to :user
  has_many :doctags
  has_many :tags, through: :doctags

  mount_uploader :photo, PhotoUploader
end
