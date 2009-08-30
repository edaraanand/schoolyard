# Stop merb-auth-password-slice from loading the default strategy
MerbAuthSlicePassword[:no_default_strategies] = true
 
# Merb::Authentication.activate!(:default_basic_auth)
# Merb::Authentication.activate!(:default_password_form)
 
# My Multisite strategy
class Merb::Authentication
  module Strategies
    module Multisite
 
      class Base < Merb::Authentication::Strategy
        abstract!
 
        # Overwrite this method to customize the field
        def self.password_param
          (Merb::Plugins.config[:"merb-auth"][:password_param] || :password).to_s.to_sym
        end
 
        # Overwrite this method to customize the field
        def self.login_param
          (Merb::Plugins.config[:"merb-auth"][:login_param] || :login).to_s.to_sym
        end
 
        # Overwrite this method to customize the field
        def self.site_id_param
          (Merb::Plugins.config[:"merb-auth"][:site_id_param] || :site_id).to_s.to_sym
        end
 
        def password_param
          @password_param ||= Base.password_param
        end
 
        def login_param
          @login_param ||= Base.login_param
        end
 
        def site_id_param
          @site_id_param ||= Base.site_id_param
        end
        
        
     
      end # Base      
 
      class Form < Base
 
        def run!
 
          if (login = request.params[login_param]) && (password = request.params[password_param]) && (site_id = request.params[site_id_param])
               # see if user exists for the site_id
               # user = user_class.first(login_param => login, site_id_param => site_id)
               user = user_class.find(:first, :conditions => ["email= ? and school_id = ?", login, site_id] )
              if user
                 user = user_class.authenticate(login, site_id, password)
                 if !user
                     errors = request.session.authentication.errors
                     errors.clear!
                     errors.add(login_param, strategy_error_message)
                 end
                 user
              else
                 errors = request.session.authentication.errors
                 errors.clear!
                 errors.add(login_param, strategy_error_message)
                 nil
              end
           end
           
         end # run!
        
  
        def strategy_error_message
          "#{login_param.to_s.capitalize} or #{password_param.to_s.capitalize} were incorrect"
        end
        
         
       
      end # Form
      
    end # Multisite Password
  end # Strategies
  
  
end # Authentication
