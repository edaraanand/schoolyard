class Application < Merb::Controller
  
  before :authenticate
  
  def authenticate
    redirect url(:login) unless current_user
  end
  
  
end