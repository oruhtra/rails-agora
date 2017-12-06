class Tag < ApplicationRecord
  has_many :doctags
  has_many :documents, through: :doctags

  validates :name, presence: true, uniqueness: true

  # get all remaining tags of documents selected from a firest array of tags
  def self.remaining_tags(tags_array)
    documents = Document.user_documents_tagged(tags_array)
    documents.map { |d| d.tags }.flatten.uniq - tags_array
  end

  # get tags from tagnames
  def self.tag_from_tagnames(tagsname_array)
    tagsname_array.map { |n| Tag.where(name: n).first }
  end

   # get tags from tagnames
  def self.tagnames_from_tags(tags_array)
    tags_array.map { |t| t.name }
  end

  # calc tag occurrence
  def occurrence
    self.doctags.length
  end

end
