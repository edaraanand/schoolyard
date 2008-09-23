class Users < Application

  layout 'admin'
  before :access_rights, :exclude => [:account, :account_update, :account_edit, :change_password, :password_update]


  def index
    # @users = User.paginate :page => params[:page], :order => 'username', :per_page => 2
    @users = User.find(:all, :order => 'username')
    render
  end

  def new
    @user = User.new(:content_access => true)
    render
  end

  def create
    @user = User.new(params[:user].merge(:password => 'test'))
    @user.content_access = true
     puts @user.inspect
    if @user.save  
      @user.new_password_key
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
    @user = current_user
    render :layout => 'myaccount'
  end

  def account_edit
    @user = current_user
    render :layout => 'myaccount'
  end

  def account_update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect url(:account)
    else
      flash[:error1] = "Your Account Details is not updated"
      render :account_edit, :layout => 'myaccount'
    end
  end

  def change_password
    @user = current_user
    render :layout => 'myaccount'
  end

  def password_update
    @user = current_user
    if  User.authenticate(@user.email, params[:user][:old_password])
      if (( params[:user][:password] == params[:user][:password_confirmation]) && !params[:user][:password_confirmation].blank?)
        if @user.update_attributes(params[:user])
          redirect url(:account)
        else
          flash[:error1] = "Your Password is not updated"
          render :change_password, :layout => 'myaccount'
        end
      else
        flash[:error2] = "Your Password doesn't match"
        render :change_password, :layout => 'myaccount'
      end

    else
      flash[:error3] = "Your current password doesn't match existing password"
      render :change_password, :layout => 'myaccount'
    end
  end


  private

  def access_rights
    unless current_user.manage_access == true
      redirect url(:homes)
    end
  end




end
