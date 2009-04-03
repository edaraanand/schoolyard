class WelcomeMessages < Application
 
  layout 'default'
  before :find_school
  before :rooms, :only => [:new, :create, :edit, :update]
  before :access_rights
  
  
  def index
       classrooms
    if params[:label] == "home_messages"
       @w_messages = @current_school.welcome_messages.find(:all, :conditions => ['access_name =?', "Home Page"])
    else
       @welcome_messages = @current_school.welcome_messages.find(:all, :conditions => ['access_name =?', params[:access_name]])
       if params[:access_name].nil?
          @welcome = @current_school.welcome_messages.find(:all)
       end
       if params[:access_name] == "All Messages"
          @all_messages = @current_school.welcome_messages.find(:all)
       end
    end
     render
  end
  
  def new
     @welcome_message = WelcomeMessage.new
     render                            
  end

  def create
    #if params[:access_name] != ""
       @welcome_message = @current_school.welcome_messages.new(params[:welcome_message])
       @welcome_message.person_id = @current_user.id
        if @welcome_message.save
	         redirect resource(:welcome_messages)
        else
	         render :new
        end
  end
  
  def edit
     @welcome_message = WelcomeMessage.find(params[:id])
     render
  end
  
  def update
     @welcome_message = WelcomeMessage.find(params[:id])
     if @welcome_message.update_attributes(params[:welcome_message])
	      @welcome_message.person_id = @current_user.id
	      redirect resource(:welcome_messages)
     else
	      render :edit
     end
  end
  
  def delete
      WelcomeMessage.find(params[:id]).destroy
      redirect resource(:welcome_messages)
  end
  
  def preview
     render :layout => 'preview'
  end
   
  private
  
  def classrooms
     @class = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
     room = @class.collect{|x| x.class_name.upcase }
     @classrooms = room.insert(0, "All Messages")
     @classrooms = room.insert(1, "Home Page")
  end
  
  def rooms
      @class = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
      room = @class.collect{|x| x.class_name.upcase }
      @classrooms = room.insert(0, "Home Page")
  end
   
   def access_rights
     @selected = "welcome_messages"
     have_access = false
     @view = Access.find_by_name('view_all')
     @ann = Access.find_by_name('welcome_messages')
     @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
     @access_people.each do |f|
       have_access = (f.all == true) || (f.access_id == @ann.id)
       break if have_access
     end
     unless have_access
       redirect resource(:homes)
     end
  end  
  
end
