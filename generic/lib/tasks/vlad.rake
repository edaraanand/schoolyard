begin
  require 'rubygems'
  require 'vlad'
  Vlad.load
rescue LoadError
  puts 'Could not load Vlad'
end
