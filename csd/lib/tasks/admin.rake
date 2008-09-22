namespace :db do
  desc "create default admin user"
  task :create_admin => :environment do
    admin = User.create(:name => "admin", :username => "administration",
                        :email => "niket.patel@insightmethods.com",
                        :password => "admin",
                        :password_confirmation => "admin"
                        :manage_access => "true",
                        :content_access => "true",
                        :settings_access => "true",
                        :event_access => "true",
                        :message_access => "true",
                        :links_access => "true",
                        :announcement_access => "true",
                        :files_access => "true")
      admin.save
   end
end
                        
