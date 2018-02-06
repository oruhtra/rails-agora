class Document < ApplicationRecord
  belongs_to :user, optional: true
  has_many :doctags, dependent: :destroy
  has_many :tags, through: :doctags

  validates :source, presence: true, inclusion: { in: %w(user_added email_sent supplier_scrapped email_scrapped prototype)}

  after_create :get_number_of_pages

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

  # get all user documents with a tag
  def self.user_documents_tagged(tags_array, user)
    Document.where(user: user).select{ |d| tags_array & d.tags == tags_array }
  end

  def self.user_documents_selected(user)
    Document.where(user: user).where(selected: true)
  end

  def check_and_add_tag_to_document(tag_name, date_boolean = false)
    if date_boolean
      t = Tag.get_tag_from_date(tag_name)
      if t
        # check if document doesn't already include the tag, if it doesn't create a new doctag
        if !self.tags.include?(t)
          doctag = Doctag.new
          doctag.document = self
          doctag.tag = t
          doctag.save
        end
      end
    else
      tag_name.downcase!
      # searching all tags that match part of the name and creat
      if !Tag.tag_from_match_in_name(tag_name).first.nil?
        Tag.tag_from_match_in_name(tag_name).each do |t|
          # check if document doesn't already include the tag, if it doesn't create a new doctag
          if !self.tags.include?(t)
            doctag = Doctag.new
            doctag.document = self
            doctag.tag = t
            doctag.save
          end
        end
      end
    end
  end

  def add_one_tag_to_document(tag)
    if !self.tags.include?(tag)
      doctag = Doctag.new
      doctag.document = self
      doctag.tag = tag
      doctag.save
    end
  end

  private

  def get_number_of_pages
    GetNumberOfPagesJob.set(wait: 15.seconds).perform_later(self)
  end

end
