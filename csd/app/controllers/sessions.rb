class Sessions < Application
  
  skip_before :authenticate
  
  def new
    @user = User.new
    render
  end
  
  def create
    session[:user_id] = User.find_by_email(params[:user][:email]).id
    redirect url(:school)
  end
  
  def destroy
    session[:user_id] = nil
    redirect '/login'
  end
  
end
