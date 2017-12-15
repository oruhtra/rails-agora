class Document < ApplicationRecord
  belongs_to :user
  has_many :doctags, dependent: :destroy
  has_many :tags, through: :doctags

  mount_uploader :photo, PhotoUploader

  # get an array of tags name
  def tagsname
    self.tags.map {|tag| tag.name}
  end

  def get_image_ratio
    doc_width = Cloudinary::Api.resource(self.photo.file.public_id)["width"]
    doc_height = Cloudinary::Api.resource(self.photo.file.public_id)["height"]
    return doc_height.to_f / doc_width.to_f
  end

  # get all user documentsw with a tag
  def self.user_documents_tagged(tags_array)
    Document.all.select{ |d| tags_array & d.tags == tags_array }
  end

  def self.user_documents_selected
    Document.where(selected: true)
  end
end
