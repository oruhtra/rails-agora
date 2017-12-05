class Document < ApplicationRecord
  belongs_to :user
  has_many :doctags, dependent: :destroy
  has_many :tags, through: :doctags

  mount_uploader :photo, PhotoUploader


  # get an array of tags name
  def tagsname
    self.tags.map {|tag| tag.name}
  end

end
