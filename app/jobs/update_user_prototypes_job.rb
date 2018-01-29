class UpdateUserPrototypesJob < ApplicationJob
  queue_as :default

  def perform(user)
    user = User.find(user.id)
    update_user_prototypes(user)
  end

  def update_user_prototypes(user)
    # update user prototypes photo by creating a new photo in cloudinary so that when the user destroys the prototypes it does not destroy the images for every one else
    user.documents.where(prototype: true).each do |d|
      d.update(remote_photo_url: "http://res.cloudinary.com/#{ENV['CLOUDINARY_URL'].match(/@(.*)/)[1]}/#{d.photo.file.identifier}")
    end
  end
end
