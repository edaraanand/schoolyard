class Application < Merb::Controller

   require Merb.root / 'app' / 'helpers' / 'global_helpers'
   include Merb::GlobalHelpers
   
    before :find_school
      
    def find_school
        @select = "schools"
        if (request.first_subdomain != nil) && (request.first_subdomain == "admin")
            @current_school = School.find(:first, :conditions => ['subdomain = ?', request.first_subdomain ] )
        elsif  (request.first_subdomain != nil) && (request.first_subdomain != "admin")
            @current_school = School.find(:first, :conditions => ['subdomain = ?', request.first_subdomain ] )
        else
            @current_school = School.find(:first, :conditions => ['domain = ?', request.domain ] )
        end
    end
    
end