class Application < Merb::Controller
  
    before :authenticate
  
  def current_user
      @current_user ||= Person.find_by_id(session[:user_id])
  end
  
  def authenticate
      redirect url(:login) unless current_user
  end

      
 # include MerbAuth::ControllerMixin

   # before :login_required
    
end