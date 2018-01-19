class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :documents, dependent: :destroy
  has_many :tags, through: :documents
  has_many :user_services, dependent: :destroy
  has_many :services, through: :user_services
  has_many :user_preferences, dependent: :destroy

  mount_uploader :photo, PhotoUploader

  after_create :send_welcome_email

  def tags
    self.documents.map {|d| d.tags}.flatten.uniq
  end

  def tagsname
    self.tags.map { |t| t.name }.flatten.uniq
  end

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end

end
