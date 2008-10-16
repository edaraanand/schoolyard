class Sessions < Application
  
     skip_before :authenticate
  
  def new
    @user = User.new
   # @person = Person.find_by_email(params[:user][:email])
     # @access = Access.find(:first, :conditions => ['name=?', "view_all"])
     # @access_id = AccessPeople.find(:all, :conditions => ['person_id=?', @person.id ])
    render
  end
  
  def create
     # @person = Person.find_by_email(params[:user][:email])
     # @access = Access.find(:first, :conditions => ['name=?', "view_all"])
    #  @access_id = AccessPeople.find(:all, :conditions => ['person_id=?', @person.id ])
    #  @access_id.each do |f|
        # if f.access_id == @access.id
            session[:user_id] = Person.find_by_email(params[:user][:email]).id
            redirect url(:schools)
        # else
	#	 redirect '/'
	# end
       #end
  end
  
  def destroy
     session[:user_id] = nil
     redirect '/'
  end
  
end
