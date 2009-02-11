class Application < Merb::Controller

  
    before :find_school
    
   # before :school
 
   # def find_school
      #  if (request.first_subdomain != nil) 
      #      @current_school = School.find(:first, :conditions => ['subdomain = ?', request.first_subdomain ] )
     #   else
      #      @current_school = School.find(:first, :conditions => ['domain = ?', request.domain ] )
     #   end
  #  end
   
  # def find_school
    #  @current_school = session.user.school unless session.user.blank?
  # end
  
   # def school
     #  if (request.first_subdomain != nil) && (request.first_subdomain == "admin")
        #   raise "Eshwar".inspect
      # elsif  (request.first_subdomain != nil) && (request.first_subdomain != "admin")
       #    raise "raja".inspect
      # else
         #  raise "gouthama".inspect
     #  end
   #  end
   
   
    def find_school
        if (request.first_subdomain != nil) && (request.first_subdomain == "admin")
            @current_school = School.find(:first, :conditions => ['subdomain = ?', request.first_subdomain ] )
        elsif  (request.first_subdomain != nil) && (request.first_subdomain != "admin")
            @current_school = School.find(:first, :conditions => ['subdomain = ?', request.first_subdomain ] )
        else
            @current_school = School.find(:first, :conditions => ['domain = ?', request.domain ] )
        end
    end
  
end