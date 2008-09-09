class Application < Merb::Controller
    

    include MerbAuth::ControllerMixin

    before :login_required
  
  
end
