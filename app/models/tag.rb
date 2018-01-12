class Tag < ApplicationRecord
  has_many :doctags
  has_many :documents, through: :doctags

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true, inclusion: { in: %w(macro_category doc_type supplier user_specific date)}

  # get all remaining tags of documents selected from a first array of tags
  def self.remaining_tags(tags_array)
    documents = Document.user_documents_tagged(tags_array)
    documents.map { |d| d.tags }.flatten.uniq - tags_array
  end

  # get tags from tagnames
  def self.tag_from_tagnames(tagsname_array)
    tagsname_array.map { |n| Tag.where(name: n).first }
  end

   # get tagnames from tags
  def self.tagnames_from_tags(tags_array)
    tags_array.map { |t| t.name }
  end

  # get tags that match a part of a name
  def self.tag_from_match_in_name(string)
    tags = Tag.all.select { |t| string.match(/\b#{t.name_clean}\b/) }
  end

  # calc tag occurrence
  def occurrence
    self.doctags.length
  end

  # get tag name with "_" replaced by whitespaces
  def name_clean
    self.name.gsub(/_/, " ")
  end

end
