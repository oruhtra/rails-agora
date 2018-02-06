class DestroyUserPrototypesJob < ApplicationJob
  queue_as :default

  def perform
    t = Time.now
    User.all.each do |user|
      if (t - User.last.created_at) > 86400
        destroy_user_prototypes(user)
      end
    end
  end

  def destroy_user_prototypes(user)
    user.documents.where(prototype: true).each do |d|
      if d.prototype
        d.destroy
      end
    end
  end

end
