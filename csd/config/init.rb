
Gem.clear_paths
Gem.path.unshift(Merb.root / "gems")

require  Merb.root / 'lib' / 'smtp_tls'
dependencies "merb-assets", "merb_helpers", "merb_paginate"
dependency "merb_has_flash"
#require 'merb_paginate/finders/activerecord'
#require 'gems/gems/merb_paginate/lib/merb_paginate/finders/activerecord'
dependency "merb-slices"
dependency "merb-auth"
dependency "merb_paginate"
dependency "merb-mailer"


Merb::BootLoader.after_app_loads do
  # Add dependencies here that must load after the application loads:
  Merb::Slices::config[:merb_auth][:layout] = :application
  # MerbAuth[:use_activation] = true
  MerbAuth[:forgotten_password] = true
  # dependency "magic_admin" # this gem uses the app's model classes

  Merb::Mailer.config = {
    :host   => 'smtp.gmail.com',
    :port   => '587',
    :user   => 'eshwar1314@gmail.com',
    :pass   => 'ashwini13',
    :auth   => :plain 
  }
 
end

use_orm :activerecord
use_test :rspec


use_template_engine :erb
# use_template_engine :haml



Merb::Config.use do |c|

  # Sets up a custom session id key which is used for the session persistence
  # cookie name.  If not specified, defaults to '_session_id'.
  c[:session_id_key] = '_csd_id'
  
  # The session_secret_key is only required for the cookie session store.
  c[:session_secret_key]  = '88ae25d7374e255b8d934c1169bc1cfc36f9f89c'
  
  # There are various options here, by default Merb comes with 'cookie', 
  # 'memory' or 'memcached'.  You can of course use your favorite ORM 
  # instead: 'datamapper', 'sequel' or 'activerecord'.
  c[:session_store] = 'cookie'
end


