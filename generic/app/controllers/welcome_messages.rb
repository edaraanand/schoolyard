class WelcomeMessages < Application

  def index
     @access_rights = @current_user.accesses_without_all
     @welcome_messages = WelcomeMessage.find(:all, :conditions => ['access_name =?', params[:access_name]])
     render
  end
  
  def new
     @welcome_message = WelcomeMessage.new
     @access_rights = @current_user.accesses_without_all
     render                            
  end

  def create
     @welcome_message = WelcomeMessage.new(params[:welcome_message])
     @welcome_message.person_id = @current_user.id
     @welcome_message.save
     redirect url(:welcome_messages)
  end
  
  def edit
     @welcome_message = WelcomeMessage.find(params[:id])
     @access_rights = @current_user.accesses_without_all
     render
  end
  
  def update
     @welcome_message = WelcomeMessage.find(params[:id])
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
   
end
