class Sessions < Application
  
  skip_before :authenticate# , :only => [:new, :create]
  
  def new
    @user = User.new
    render 
  end
  
  def create
     session[:user_id] = User.authenticate(params[:user][:email]).id
     if current_user && current_user.enabled
        redirect url(:schools)
     else
        render :action => 'new'
     end
  end
  
  def destroy
    session[:user_id] = nil
    redirect '/login'
  end
  
end
