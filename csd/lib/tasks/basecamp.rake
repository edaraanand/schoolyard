require 'basecamp'
require 'constantz'

namespace :basecamp do
  desc "Use this task to send automated build notification"
  task :notify do
    session = Basecamp.new('insightmethods.grouphub.com', Csd.config(:bc_user), Csd.config(:bc_password), true)
    puts "#{session.create_comment(14551759, {:body => ENV['BUILD_MSG']})}"
  end
end