
Gem.clear_paths
Gem.path.unshift(Merb.root / "gems")


# ==== Dependencies

require 'ftools'
require 'config/dependencies.rb'
require  Merb.root / 'lib' / 'smtp_tls'
require  Merb.root / 'lib' / 'constantz'
require  Merb.root / 'lib' / 'attachable'


  use_orm :activerecord
  use_test :rspec
  #use_template_engine :erb
  
Merb::BootLoader.after_app_loads do
	
  # Paperclip::Configure::enable_ar!
    #Merb::Slices::config[:merb_auth][:layout] = :application
   #MA[:forgotten_password] = true 
  # Add dependencies here that must load after the application loads:
    
  # dependency "magic_admin" # this gem uses the app's model classes
  Merb::Mailer.config = {
    :host   => 'smtp.gmail.com',
    :port   => '587',
    :user   => Schoolapp.config(:auth_mailman),
    :pass   => Schoolapp.config(:mailman_password),
    :auth   => :plain 
  }
  
  #Merb::Mailer.config = { :sendmail_path => /usr/sbin/sendmail}
  #Merb::Mailer.delivery_method = :sendmail

end

# ==== Set up your basic configuration

Merb::Config.use do |c|

  # Sets up a custom session id key, if you want to piggyback sessions of other applications
  # with the cookie session store. If not specified, defaults to '_session_id'.
  c[:session_id_key] = '_scapp_session_id'

  c[:session_secret_key]  = 'cb559b9d1afded91073666b345eebe8e8f41f213'
  c[:session_store] = 'cookie'
  c[:disabled_components] = [:signals]
end


