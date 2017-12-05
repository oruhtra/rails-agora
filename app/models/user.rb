class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :documents, dependent: :destroy
  has_many :tags, through: :documents
  mount_uploader :photo, PhotoUploader

  def tags
    self.documents.map {|d| d.tags}.flatten.uniq
  end

  def tagsname
    self.tags.map { |t| t.name }.flatten.uniq
  end
end
