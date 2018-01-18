desc "This task is called by the Heroku scheduler add-on - scrapping all users documents"
task :scrap_for_all_users => :environment do
  User.all.each do |user|
    ScrapJob.perform_later(user.id)
  end
end
