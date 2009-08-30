Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')
namespace :feedback do
    
    desc "creating a school profile access"
    task :person do
        access = { :feedback => "Manage Feedback"}
        access.each_pair do |key, value|
            Access.create({:name => "#{key}", :full_name => "#{value}"})
        end
    end
end
