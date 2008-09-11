class MerbAuth::Users < MerbAuth::Application
  provides :html

  skip_before :login_required
  
  def login
    if request.post?
          @user = User.find_by_email(params[:email])
       if @user.content_access == true
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
      end
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

  

end
