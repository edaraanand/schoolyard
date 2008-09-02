class Homelinks < Application

  # ...and remember, everything returned from an action
  # goes to the client...
  def index
    render
  end
  
  def new
    @homelink = Homelink.new
     render
  end

   def create
     render
   end
    
   def edit
      render
   end
end
