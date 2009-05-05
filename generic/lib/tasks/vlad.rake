begin
  require 'vlad'
  Vlad.load :app => :schoolapp, :scm => :git
rescue LoadError
  puts 'Could not load Vlad'
end
