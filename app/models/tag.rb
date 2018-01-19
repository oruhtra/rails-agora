class Tag < ApplicationRecord
  has_many :doctags
  has_many :documents, through: :doctags

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true, inclusion: { in: %w(macro_category doc_type supplier user_specific date)}

  # get all remaining tags of documents selected from a first array of tags
  def self.remaining_tags(tags_array, user)
    documents = Document.user_documents_tagged(tags_array, user)
    documents.map { |d| d.tags }.flatten.uniq - tags_array
  end

  # get tags from tagnames
  def self.tag_from_tagnames(tagsname_array)
    tagsname_array.map { |n| Tag.get_tag_from_date(n) || Tag.where(name: n).first }
  end

   # get tagnames from tags
  def self.tagnames_from_tags(tags_array)
    tags_array.map { |t| t.name }
  end

  # get tags that match a part of a name
  def self.tag_from_match_in_name(string)
    string.downcase!
    Tag.all.select { |t| string.match(/\b#{t.name_clean}\b/) }
  end

  # calc tag occurrence
  def occurrence
    self.doctags.length
  end

  # get tag name with "_" replaced by whitespaces
  def name_clean
    self.name.gsub(/_/, " ")
  end

  # get tag from date
  def self.get_tag_from_date(date_string)
    begin
      name = date_string.to_date.strftime("%b %Y").gsub(/\s/, "_")
      if Tag.where(name: name).first
        return Tag.where(name: name).first
      else
        return Tag.create(name: name, category: 'date')
      end
    rescue
      false
    end
  end

end
