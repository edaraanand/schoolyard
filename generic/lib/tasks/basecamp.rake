require 'lib/basecamp'
require 'lib/constantz'

namespace :basecamp do
  desc "Use this task to send automated build notification"
  task :notify do
    session = Basecamp.new('insightmethods.grouphub.com', Schoolapp.config(:bc_user), Schoolapp.config(:bc_password), true)
    puts "#{session.create_comment(16400436, {:body => ENV['BUILD_MSG']})}"
  end

  desc "Send deploymet notification"
  task :notify_new_build do
    git_log = `git-log --abbrev-commit --pretty=format:"%s%n<a href=https://github.com/eshwardeep/schoolapp/commit/%H target=_blank>%h</a> by (%an: %ar)%n" ee874f7..HEAD --no-merges`
    build_msg = <<-EOF
    <a href=http://sdb.schoolyardapp.com target=_blank>New build ( http://sdb.schoolyardapp.com )</a> is just pushed to server. 
      ...
      <b>Change Log:</b>
      #{git_log}
    EOF
    build_msg.strip!
    build_msg.gsub!('"', '\"')
    build_msg.gsub!(/\n/, '<br />')
    `rake basecamp:notify BUILD_MSG="#{build_msg}"`
  end
end
