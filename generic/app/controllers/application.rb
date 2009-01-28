class Application < Merb::Controller

  
   before :find_school
  
    def find_school
       if request.first_subdomain != nil
         @current_school = School.find(:first, :conditions => ['subdomain = ?', request.first_subdomain ] )
         # @current_school = School.first(:subdomain => request.first_subdomain)
       else
         # @current_school = School.first(:domain => request.domain)
          @current_school = School.find(:first, :conditions => ['domain = ?', request.domain ] )
       end
    end
   
  # def find_school
    #  @current_school = session.user.school unless session.user.blank?
  # end
  
end