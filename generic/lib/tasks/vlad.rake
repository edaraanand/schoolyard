begin
  require 'rubygems'
  require 'vlad'
  Vlad.load(:scm => :git, :app => nil, :web => nil)
rescue LoadError
  puts 'Could not load Vlad'
end
