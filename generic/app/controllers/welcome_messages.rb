class WelcomeMessages < Application

  def index
     classrooms
     @welcome_messages = WelcomeMessage.find(:all, :conditions => ['access_name =?', params[:access_name]])
     render
  end
  
  def new
     @welcome_message = WelcomeMessage.new
     classrooms
     render                            
  end

  def create
     @welcome_message = WelcomeMessage.new(params[:welcome_message])
     @welcome_message.person_id = @current_user.id
     classrooms
     if @welcome_message.save
        redirect url(:welcome_messages)
     else
	render :new
     end
  end
  
  def edit
     @welcome_message = WelcomeMessage.find(params[:id])
     classrooms
     render
  end
  
  def update
     @welcome_message = WelcomeMessage.find(params[:id])
     classrooms
     if @welcome_message.update_attributes(params[:welcome_message])
	@welcome_message.person_id = @current_user.id
	redirect url(:welcome_messages)
     else
	render :edit
     end
  end
  
  def delete
      WelcomeMessage.find(params[:id]).destroy
      redirect url(:welcome_messages)
  end
  
  def preview
     render :layout => 'preview'
  end
   
  private
  
  def access_rights
     @access_people = @current_user.access_peoples
     @accesses = Access.find(:all)
      @accesses.each do |f|
	have_access = false
        @access_people.each do |l|
	  have_access = l.all || (f.id == l.access_id) 
	  break if have_access	
	end
	if have_access
	   @access_rights =  @accesses.delete_if{|x| x.name == "view_all"}
	else
	   @access_rights = @current_user.accesses_without_all
	end
      end
  end
  
  def classrooms
     @class = Classroom.find(:all)
     room = @class.collect{|x| x.class_name }
     @classrooms = room.insert(0, "HomePage")
  end
  
end
