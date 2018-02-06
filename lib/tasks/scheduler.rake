desc "This task is called by the Heroku scheduler add-on - scrapping all users documents"
task :scrap_for_all_users => :environment do
  User.all.each do |user|
    ScrapWorker.perform_async(user.id, 0)
  end
end

desc "This task is called by the Heroku scheduler add-on - destroy all user prototypes"
task :destroy_prototypes_for_all_users => :environment do
  DestroyUserPrototypesJob.perform_later
end
