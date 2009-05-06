begin
  require 'rubygems'
  require 'vlad'
  Vlad.load(:app => :passenger, :scm => :git )
rescue LoadError
  puts 'Could not load Vlad'
end
