class MerbAuth::Users < MerbAuth::Application
  provides :html

  skip_before :login_required
  
  def login
    if request.post?
       #  @user = MerbAuth::User.find_by_email(params[:email])
      #  if @user.content_access == true
          self.current_user = verify_login(params[:email], params[:password])
             if logged_in?
               if params[:remember_me] == "1"
                    self.current_user.remember_me
                    cookies[:auth_token] = {
                       :value => self.current_user.remember_token, 
                       :expires => Time.parse(current_user.remember_token_expires_at.strftime)
                      }
               end
                 return redirect_back_or_default('/')
             end
        #end
    end
      
    render
  end

  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    redirect_back_or_default('/')
  end

  def signup
    cookies.delete :auth_token
    @user = MerbAuth::User.new(params['merb_auth::user'] || {})
   
    if request.post? && @user.save
     return redirect_back_or_default('/')
    end
    
    render
  end

  def forgot_password
     render
  end

  def reset_password
       email = params[:email]
       @ivar = MerbAuth::User.find(:first, :conditions => ['email=?', email])
         raise Notfound if @ivar.nil?
         raise Unauthorized if logged_in? && @ivar != current_user
         @ivar.reset_pass
         set_ivar
      puts "Ashwini"
        return redirect_back_or_default('/')
  end

  def reset_password_edit
      @user = self.current_user
    # puts @ivar.inspect
      #set_ivar
      render
  end

  def reset_password_link
     id = params[:id]
     @user = MerbAuth::User.find(:first, :conditions => ['password_reset_key = ?', id])
       if @user.nil?
          redirect_back_or_default "/"
       else
          self.current_user = @user
          #set_ivar
          redirect url(:reset_password_edit)
       end
  end

  def reset_password_update
      @user = current_user
      puts @user.inspect
  

    if !params[:user][:password].blank?
    
       if (( params[:user][:password] == params[:user][:password_confirmation]) && !params[:user][:password_confirmation].blank?)
         
           if !@user.has_forgotten_password?
               if @user != MerbAuth::User.authenticate(@user.email, params[:current_password])
                  message[:notice] = "Your current password is incorrect"
                  return render(:reset_password_edit)
               end
           end

          @user.password = params[:user][:password]
          @user.password_confirmation = params[:user][:password_confirmation]
    
         if @user.save
            redirect_back_or_default("/")
         else
            redirect url(:reset_password_edit)
         end

       else
          flash[:error] = "Your current password doesn't match existing password"
          return render(:reset_password_edit)
       end
    else
        flash[:error1] = "You must enter a password"
        return render(:reset_password_edit)
     end
  end

  private

    def set_ivar
       instance_variable_set("@#{MerbAuth[:single_resource]}", @ivar)
    end
    


end












