class Users < Application
  
  def index
     @users = User.paginate :page => params[:page], :order => 'username', :per_page => 2
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
      
  def account
     @user = User.find(:first, :conditions => ['id=?', current_user.id] ) 
     render :layout => 'myaccount'
  end

  def account_edit
     @user = User.find(:first, :conditions => ['id=?', current_user.id] ) 
     render :layout => 'myaccount'
  end

  def account_update
      @user = User.find(:first, :conditions => ['id=?', current_user.id] )
      if  User.authenticate(params[:user][:email], params[:user][:old_password])
           
    if (( params[:user][:password] == params[:user][:password_confirmation]) && !params[:user][:password_confirmation].blank?)
              if @user.update_attributes(params[:user])
                  redirect url(:account)
              else
                  flash[:error1] = "Your Account Details is not updated"
                  render :account_edit, :layout => 'myaccount'
              end
          else
              flash[:error2] = "Your Password doesn't match"
              render :account_edit, :layout => 'myaccount'
          end 

      else
	  flash[:error3] = "Your current password doesn't match existing password"
          render :account_edit, :layout => 'myaccount'
      end
    
     
  end

end
