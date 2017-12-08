class Document < ApplicationRecord
  belongs_to :user
  has_many :doctags, dependent: :destroy
  has_many :tags, through: :doctags

  mount_uploader :photo, PhotoUploader


  # get an array of tags name
  def tagsname
    self.tags.map {|tag| tag.name}
  end

  # get all user documentsw with a tag
  def self.user_documents_tagged(tags_array)
    Document.all.select{ |d| tags_array & d.tags == tags_array }
  end

  def self.user_documents_selected
    Document.where(selected: true)
  end
end
