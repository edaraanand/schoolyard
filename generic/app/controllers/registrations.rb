class Registrations < Application

  before :month_year
  
  def index
    render
  end
  
  def new
    @parent = Parent.new
    @registration = Registration.new
    render
  end
  
  def create
    @parent = Parent.new(params[:parent])
    @registration = Registration.new(params[:registration])
    if ( ( (params[:f_name_student2] == "") && (params[:l_name_student2] == "") ) &&  ( (params[:current_class2] == "") &&  (params[:birth_date2] == "") ) )
          if (@parent.valid?) && (@registration.valid?)
               @parent.save
               @registration.parent_id = @parent.id
               @registration.save
               redirect url(:registration_process, :id => @parent)
          else 
              render :new
          end
      else
        if (@parent.valid?) && (@registration.valid?)
           if ( ( (params[:f_name_student2] != "") && (params[:l_name_student2] != "") ) &&  ( (params[:current_class2] != "") &&  (params[:birth_date2] != "") ) )
               if ( ( (params[:f_name_student3] != "") || (params[:l_name_student3] != "") ) || (params[:current_class3] != "") )
                    if ( ( (params[:f_name_student4] !="") || (params[:l_name_student4] != "") ) || (params[:current_class4] != "") )
                        if ( ( (params[:f_name_student4] != "") && (params[:l_name_student4] != "") ) &&  ( (params[:current_class4] != "") &&  (params[:birth_date4] != "") ) )
                              if (@parent.valid?) && (@registration.valid?)
                                       @parent.save
                                       @registration.parent_id = @parent.id
                                       @registration.save
                                       Registration.create({ :first_name => params[:f_name_student2], :last_name => params[:l_name_student2], :birth_date => params[:birth_date2], :current_class => params[:current_class2], :parent_id => @parent.id } )                               
                                       Registration.create({:first_name => params[:f_name_student3], :last_name => params[:l_name_student3], :birth_date => params[:birth_date3], :current_class => params[:current_class3], :parent_id => @parent.id  })                                 
                                       Registration.create({:first_name => params[:f_name_student4], :last_name => params[:l_name_student4], :birth_date => params[:birth_date4], :current_class => params[:current_class4], :parent_id => @parent.id  })
                                       redirect url(:registration_process, :id => @parent)
                                    
                              else
                                   flash[:error4] = "Please enter the Student4 details"
                                   @fname4 = params[:f_name_student4]
	                                 @lname4 = params[:l_name_student4]
	                                 @current_class4 = params[:current_class4]
                                   @birth_date4 = params[:birth_date4]
	                                 @fname3 = params[:f_name_student3]
	                                 @lname3 = params[:l_name_student3]
	                                 @current_class3 = params[:current_class3]
                                   @birth_date3 = params[:birth_date3]
                                   @fname2 = params[:f_name_student2]
	                                 @lname2 = params[:l_name_student2]
	                                 @current_class2 = params[:current_class2]
                                   @birth_date2 = params[:birth_date2]
                                   render :new 
                               end
                        else
                            flash[:error4] = "Please enter the Student4 details"
                            @fname4 = params[:f_name_student4]
	                          @lname4 = params[:l_name_student4]
	                          @current_class4 = params[:current_class4]
                            @birth_date4 = params[:birth_date4]
	                          @fname3 = params[:f_name_student3]
	                          @lname3 = params[:l_name_student3]
	                          @current_class3 = params[:current_class3]
                            @birth_date3 = params[:birth_date3]
                            @fname2 = params[:f_name_student2]
	                          @lname2 = params[:l_name_student2]
	                          @current_class2 = params[:current_class2]
                            @birth_date2 = params[:birth_date2]
                            render :new 
                        end
                   else
                        if ( ( (params[:f_name_student3] != "") && (params[:l_name_student3] != "") ) &&  ( (params[:current_class3] != "") &&  (params[:birth_date3] != "") ) )
                             if (@parent.valid?) && (@registration.valid?)
                                  @parent.save
                                  @registration.parent_id = @parent.id
                                  @registration.save
                                  Registration.create({ :first_name => params[:f_name_student2], :last_name => params[:l_name_student2], :birth_date => params[:birth_date2], :current_class => params[:current_class2], :parent_id => @parent.id } )
                                  Registration.create({:first_name => params[:f_name_student3], :last_name => params[:l_name_student3], :birth_date => params[:birth_date3], :current_class => params[:current_class3], :parent_id => @parent.id  })                                 
                                  redirect url(:registration_process, :id => @parent)
                              
                             else
                                  flash[:error3] = "Please enter the Student3 details"
                                   @fname3 = params[:f_name_student3]
	                                 @lname3 = params[:l_name_student3]
	                                 @current_class3 = params[:current_class3]
                                   @birth_date3 = params[:birth_date3]
                                   @fname2 = params[:f_name_student2]
	                                 @lname2 = params[:l_name_student2]
	                                 @current_class2 = params[:current_class2]
                                   @birth_date2 = params[:birth_date2]
                                  render :new 
                             end
                         else
                              flash[:error3] = "Please enter the Student3 details"
	                            @fname3 = params[:f_name_student3]
	                            @lname3 = params[:l_name_student3]
	                            @current_class3 = params[:current_class3]
                              @birth_date3 = params[:birth_date3]
                              @fname2 = params[:f_name_student2]
	                            @lname2 = params[:l_name_student2]
	                            @current_class2 = params[:current_class2]
                              @birth_date2 = params[:birth_date2]
                              render :new
                         end
                   end
             else
                 if (@parent.valid?) && (@registration.valid?)
                      @parent.save
                      @registration.parent_id = @parent.id
                      @registration.save
                      Registration.create({ :first_name => params[:f_name_student2], :last_name => params[:l_name_student2], :birth_date => params[:birth_date2], :current_class => params[:current_class2], :parent_id => @parent.id  } )
                      redirect url(:registration_process, :id => @parent)
                 else
                      flash[:error] = "Please enter the Student2 details"
                      @fname2 = params[:f_name_student2]
	                    @lname2 = params[:l_name_student2]
	                    @current_class2 = params[:current_class2]
                      @birth_date2 = params[:birth_date2]
                      render :new 
                  end
             end
          else
              flash[:error] = "Please enter the Student2 details"
	            @fname2 = params[:f_name_student2]
	            @lname2 = params[:l_name_student2]
	            @current_class2 = params[:current_class2]
              @birth_date2 = params[:birth_date2]
              render :new
          end  
      else
         render :new
      end
    end
    
  end
  
  
  def registration_process
    @parent = Parent.find(params[:id])
    email_verification
    render
  end
  
  def registration_last
    @parent = Parent.find(params[:id])
    @parent.approved = 2
    @parent.save
    render
  end
  
  def password_new
     id = params[:id]
     @parent = Parent.find(:first, :conditions => ['password_reset_key = ?', id])
     redirect url(:new_password, :id => @parent.id)
  end
  
  def new_password
     @parent = Parent.find(params[:id])
     render
  end
  
  def password_save
     @parent = Parent.find(params[:id])
     if ( !params[:parent][:password].blank? ) && (!params[:parent][:password_confirmation].blank? )
         if ( params[:parent][:password] == params[:parent][:password_confirmation] )
            @parent.password = params[:parent][:password]
            @parent.password_confirmation = params[:parent][:password_confirmation]
            @parent.save
            redirect url(:login)
         else
            flash[:error1] = "Your Password doesn't match"
            render :new_password
         end
    else
       flash[:error2] = "Password cant be blank"
       render :new_password
    end
  end
  
  def forgot_password
     render
  end
  
  def get_password
    if params[:email] == ""
       flash[:error] = "Please Enter your Email"
       render :forgot_password
    else
       @person = Person.find_by_email(params[:email])
       if @person.nil?
          flash[:error1] = "You should enter correct Email that you have provided for the school"
          render :forgot_password
       else
         @person.reset_password
         redirect url(:password_sent, :id => @person.id)
       end
    end
  end

  def password_sent
     @person = Person.find(params[:id])
     render
  end
  
  def reset_password
    id = params[:id]
    @person = Person.find(:first, :conditions => ['password_reset_key = ?', id])
    redirect url(:reset_password_edit, :id => @person.id )
  end
  
  def reset_password_edit
     @person = Person.find(params[:id])
     render
  end
  
  def reset_password_update
    @person = Person.find(params[:id])
    if ( !params[:person][:password].blank? ) && (!params[:person][:password_confirmation].blank? )
        if ( params[:person][:password] == params[:person][:password_confirmation] )
          @person.password = params[:person][:password]
          @person.password_confirmation = params[:person][:password_confirmation]
            if @person.save
              redirect url(:login)
            else
              redirect url(:reset_password_edit, :id => @person.id )
            end
         else
            flash[:error1] = "Your Password doesn't match"
            redirect url(:reset_password_edit, :id => @person.id )
         end
    else
       flash[:error2] = "Password cant be blank"
       redirect url(:reset_password_edit, :id => @person.id )
    end
  end
  
                               
  private
  
  def month_year
     @classrooms = Classroom.find(:all)
     @years = (1999..2020).to_a 
     @months = [ 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
  end
                                         
  def email_verification
     deliver_email(:sign_up, :subject => "Your Account is about to  Activate only if u click the link" )
  end
 
  def deliver_email(action, params)
     from = "no-reply@insightmethods.com"
     PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => @parent.email), @parent )
  end
  
end
