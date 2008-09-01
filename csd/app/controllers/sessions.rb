class Sessions < Application
  
  skip_before :authenticate
  
  def new
    @user = User.new
    render 
  end
  
  def create
     session[:user_id] = User.find_by_email(params[:user][:email]).id

    @user = User.find(:first, :conditions => ['id=?', session[:user_id]])
     if @user.disable == true
        redirect url(:school)
     else
        render :action => 'new'
     end
   # @user.update_attribute(:disable, true)
             
  end
  
  def destroy
    session[:user_id] = nil
    redirect '/login'
  end
  
end
