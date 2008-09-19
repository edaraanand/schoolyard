class Homes < Application

  # ...and remember, everything returned from an action
  # goes to the client...
  def index
     @announcement = Announcement.find(:first)
    render
  end
  
   def admin
     render :layout => 'admin'
   end
   
   def directory
     @users = User.find(:all, :order => 'username')
     render
   end

end
