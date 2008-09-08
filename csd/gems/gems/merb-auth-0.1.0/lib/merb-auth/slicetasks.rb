namespace :slices do
  namespace :merb_auth do 
    # add your own tasks here
    
    # implement this to test for structural/code dependencies
    # like certain directories or availability of other files
    desc "Test for any dependencies"
    task :preflight do
    end
    
    # implement this to perform any database related setup steps
    desc "Migrate the database"
    task :migrate do
      # MerbAuth::User.create_db_table
    end
    
  end
end