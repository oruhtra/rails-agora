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

  after_create :send_welcome_email, :create_user_seed
  before_destroy :destroy_user_specific_tags, :destroy_budgea_user

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

  def create_user_seed
    UserSeedJob.perform_now(self)
  end

  def destroy_user_specific_tags
    Tag.where(user_id: self.id).destroy_all
  end

  def destroy_budgea_user
    if self.budgea_id
      url = "https://agora.biapi.pro/2.0/users/#{self.budgea_id}"
      headers = { "Authorization": "Bearer #{self.budgea_token}" }
      RestClient.delete(url, headers)
    end
  end

end
