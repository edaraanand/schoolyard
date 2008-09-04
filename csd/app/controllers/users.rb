class Users < Application
  
  def index
     @users = User.find(:all, :order => 'last_name')
     render
  end
  
  def new
     @user = User.new(:content_access => true)
     render
  end
  
  def create 
     @user = User.new(params[:user])
     @user.content_access = true
       if @user.save
          redirect url(:users)
       else
          render :new
       end
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
          render :edit
       end
  end
  
  def disable
     @user = User.find(params[:id])
     @user.update_attribute(:content_access, false)
     redirect url(:edit_user, @user)  
  end
      
  
end
