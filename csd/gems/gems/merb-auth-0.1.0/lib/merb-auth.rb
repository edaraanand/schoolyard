if defined?(Merb::Plugins)

  load_dependency 'merb-slices'
  load_dependency 'merb_helpers'
  
  require File.join(File.dirname(__FILE__), 'merb-auth', 'model')

  Merb::Plugins.add_rakefiles "merb-auth/merbtasks", "merb-auth/slicetasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout.
  Merb::Slices::config[:merb_auth][:layout] ||= :merb_auth
  
  # Use a short name for the user model class.  Set this to false to use MerbAuth::User
  Merb::Slices::config[:merb_auth][:user_class_alias] = "User"
  
  # All Slice code is expected to be namespaced inside a module
  module MerbAuth
    # Slice metadata
    self.description = "MerbAuth is an user authentication Merb slice!"
    self.version = "0.1.0"
    self.author = "ctran@pragmaquest.com"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
      MerbAuth.use_adapter(Merb.orm_generator_scope) if Merb.orm_generator_scope != :merb_default
      Object.const_set(Merb::Slices::config[:merb_auth][:user_class_alias], MerbAuth::User) if Merb::Slices::config[:merb_auth][:user_class_alias]      
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(Bar)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    def self.setup_router(scope)
      scope.match('/login').to(:controller => 'users', :action => 'login').name(:login)
      scope.match('/logout').to(:controller => 'users', :action => 'logout').name(:logout)
      scope.match('/signup').to(:controller => 'users', :action => 'signup').name(:signup)
      scope.match('/forgot_password').to(:controller => 'users', :action => 'forgot_password').name(:forgot_password)
      scope.match('/reset_password').to(:controller => 'users', :action => 'reset_password').name(:reset_password)
      scope.match('/reset_password_edit').to(:controller => 'users', :action => 'reset_password_edit').name(:reset_password_edit)
      scope.match('/reset_password_update').to(:controller => 'users', :action => 'reset_password_update').name(:reset_password_update)
      scope.match('/reset_password_link').to(:controller => 'users', :action => 'reset_password_link').name(:reset_password_link)
      #scope.match('/reset_password_show').to(:controller => 'users', :action => 'reset_password_show').name('reset_password_show')
    end
  end
  
  # Setup the slice layout for MerbAuth
  #
  # Use MerbAuth.push_path and MerbAuth.push_app_path
  # to set paths to merb-auth-level and app-level paths. Example:
  #
  # MerbAuth.push_path(:application, MerbAuth.root)
  # MerbAuth.push_app_path(:application, Merb.root / 'slices' / 'merb-auth')
  # ...
  #
  # Any component path that hasn't been set will default to MerbAuth.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  MerbAuth.setup_default_structure!
end
