class Users < Application
   
   before :ensure_authenticated
   
  def staff_account
    @person = session.user
    render :layout => 'admin_account'
  end
  
  def staff_account_edit
    @person = session.user
    render :layout => 'admin_account'
  end
  
  def staff_account_update
    @person = session.user
    if @person.update_attributes(params[:person])
      redirect url(:staff_account)
    else
      render :staff_account_edit, :layout => 'admin_account'
    end
  end
  
  def staff_password
    @person = session.user
    render :layout => 'admin_account'
  end 
  
  def staff_password_update
    puts "Eshwar"
    @person = session.user
    if  Person.authenticate(@person.email, params[:person][:old_password])
      if (( params[:person][:password] == params[:person][:password_confirmation]) && !params[:person][:password_confirmation].blank?)
        if @person.update_attributes(params[:person])
          redirect url(:staff_account)
        else
          flash[:error1] = "Your Password is not updated"
          render :staff_password, :layout => 'admin_account'
        end
      else
        flash[:error2] = "Your Password doesn't match"
        render :staff_password, :layout => 'admin_account'
      end

    else
      flash[:error3] = "Your current password doesn't match existing password"
      render :staff_password, :layout => 'admin_account'
    end
   
  end
  
end
