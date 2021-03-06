set :repository,    "git@github.com:insightmethods/schoolyard.git"
set :revision,      "origin/master"

set :domain,        "schoolyard@dev-schoolyardapp.info"
set :deploy_to,     "/home/schoolyard/dev-schoolyardapp.info"
set :port,          5001
set :processes,     2
set :merb_env,      "internal_testing"


desc "this is for staging"
task :staging do
  set :domain,        "forge@test-schoolyardapp.info"
  set :deploy_to,     "/home/forge/test-schoolyardapp.info"
  set :port,          5000
  set :merb_env,      "staging"
end

desc "this is for production"
task :production do
  set :domain,        "forge@schoolyardapp.com"
  set :deploy_to,     "/home/forge/schoolyardapp.com"
  set :port,          4000
  set :processes,     9
  set :merb_env,      "production"
  set :revision,      "origin/production"
end



Rake.clear_tasks('vlad:stop', 'vlad:start', 'vlad:migrate')
 
namespace :vlad do

  def stop
    run "cd #{current_path} && merb -e #{merb_env} -K #{port} all"
  end

  def start
    run "cd #{current_path} && merb -e #{merb_env} -p #{port} -m #{current_path} -c #{processes}"
  end

  desc 'restart merb'
  remote_task :start, :roles => :app do
    stop
    start
  end

  desc 'stop designer'
  remote_task :stop, :roles => :app do
    stop
  end
  

  desc 'Copy production files'
  remote_task :backup, :roles => :app do
    run "tar zcf backup_before_update_#{merb_env}_#{Date.today.year}#{Date.today.month}#{Date.today.day}#{Time.now.hour}.tar #{deploy_to}"
  end


  desc 'update application rsync important files'
  remote_task :deploy, :roles => :app do
    Rake::Task["vlad:backup"].invoke
    Rake::Task["vlad:update"].invoke
    Rake::Task['vlad:copy_production_files'].invoke
    Rake::Task['vlad:copy_data_files'].invoke
    #Rake::Task['vlad:native_gems'].invoke
    Rake::Task["vlad:start"].invoke
    Rake::Task["vlad:notify"].invoke
  end

  desc 'Copy production files'
  remote_task :copy_data_files, :roles => :app do
    run "cp #{releases_path}/#{releases[releases.size - 2]}/db/production.sqlite3 #{current_path}/db/production.sqlite3"
    run "cp -r #{releases_path}/#{releases[releases.size - 2]}/public/uploads #{current_path}/public"
  end

  desc 'Copy production files'
  remote_task :copy_production_files, :roles => :app do
    rsync "#{Merb.root}/lib/constantz.rb.#{merb_env}", "#{current_path}/lib/constantz.rb"
    rsync "#{Merb.root}/config/database.yml.#{merb_env}", "#{current_path}/config/database.yml"
  end

  desc "migrate app with merb env"
  remote_task :migrate, :roles => :app do
    run "cd #{current_path} && rake db:migrate MERB_ENV=#{merb_env}"
  end


  desc "retrieve the version from the git log"
  task :update_revision do
    `git log -1 --pretty=format:'%H' > #{merb_env.upcase}_DEPLOY_REVISION`
  end
  
  desc "Send deploymet notification"
  task :notify do
    deploy_revision = `cat #{Merb.root}/#{merb_env.upcase}_DEPLOY_REVISION`
    git_log = `git log --abbrev-commit --pretty=format:"%s%n<a href=https://github.com/insightmethods/schoolyard/commit/%H target=_blank>%h</a> by (%an: %ar)%n" #{deploy_revision}..HEAD --no-merges`
    build_msg = <<-EOF
      Schoolyard has been pushed to #{merb_env} 
      ...
      <b>Change Log:</b>
      #{git_log}
    EOF
    build_msg.strip!
    build_msg.gsub!('"', '\"')
    build_msg.gsub!(/\n/, '<br />')
    `#{Merb.root}/bin/rake basecamp:notify BUILD_MSG="#{build_msg}"`
    
    Rake::Task["vlad:update_revision"].invoke
  end

end