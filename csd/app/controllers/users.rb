class Users < Application
  
  def index
    @users = User.find(:all, :order => 'last_name')
    render
  end
  
  def new
    @user = User.new
    render
  end
  
  def create
    
     @user = User.new(params[:user])
      puts @user.inspect
       @user.save
     redirect url(:users)
  end
  
  def edit
    @user = User.find(params[:id])
    render
  end
  
  def update
    @user = User.find(params[:id])
      if @user.update_attributes(params[:user])
         redirect url(:users)
      else
         render :action => 'edit'
      end
  end
  
      
  
end
