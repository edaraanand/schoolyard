Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')
namespace :bootstrap do
  
  desc "Modifying Spot Light Last Name Details"
  task :spot_light do
     @spot_lights = SpotLight.find(:all)
     @spot_lights.each do |spot_light|
       spot_light.title = "Mr"
       spot_light.last_name = "last"
       spot_light.save!
     end
  end
  
end