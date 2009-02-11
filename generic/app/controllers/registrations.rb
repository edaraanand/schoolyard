class Registrations < Application

  before :month_year
  before :find_school
  
  def index
    render
  end
  
  def new
    @parent = Parent.new
    @registration = Registration.new
    render :layout => 'application'
  end
  
  def create
    @parent = @current_school.parents.new(params[:parent])
    @registration = @current_school.registrations.new(params[:registration])
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
                                       @current_school.registrations.create({ :first_name => params[:f_name_student2], :last_name => params[:l_name_student2], :birth_date => params[:birth_date2], :current_class => params[:current_class2], :parent_id => @parent.id } )                               
                                       @current_school.registrations.create({:first_name => params[:f_name_student3], :last_name => params[:l_name_student3], :birth_date => params[:birth_date3], :current_class => params[:current_class3], :parent_id => @parent.id  })                                 
                                       @current_school.registrations.create({:first_name => params[:f_name_student4], :last_name => params[:l_name_student4], :birth_date => params[:birth_date4], :current_class => params[:current_class4], :parent_id => @parent.id  })
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
                                  @current_school.registrations.create({ :first_name => params[:f_name_student2], :last_name => params[:l_name_student2], :birth_date => params[:birth_date2], :current_class => params[:current_class2], :parent_id => @parent.id } )
                                  @current_school.registrations.create({:first_name => params[:f_name_student3], :last_name => params[:l_name_student3], :birth_date => params[:birth_date3], :current_class => params[:current_class3], :parent_id => @parent.id  })                                 
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
                      @current_school.registrations.create({ :first_name => params[:f_name_student2], :last_name => params[:l_name_student2], :birth_date => params[:birth_date2], :current_class => params[:current_class2], :parent_id => @parent.id  } )
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
     @parent = @current_school.parents.find(:first, :conditions => ['password_reset_key = ?', id])
     redirect url(:new_password, :id => @parent.id)
  end
  
  def new_password
     @parent = @current_school.parents.find(params[:id])
     render
  end
  
  def password_save
     @parent = @current_school.parents.find(params[:id])
     if ( !params[:parent][:password].blank? ) && (!params[:parent][:password_confirmation].blank? )
         if ( params[:parent][:password] == params[:parent][:password_confirmation] )
            @parent.password = params[:parent][:password]
            @parent.password_confirmation = params[:parent][:password_confirmation]
            @parent.school_id = @current_school.id
            if @parent.save
               redirect url(:login)
            else
               flash[:error] = "You should enter Minimum Lengthof 4 Characters"
               redirect url(:new_password, :id => @parent.id)
            end
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
     render :layout => 'login'
  end
  
  def get_password
     if params[:email] == ""
        flash[:error] = "Please Enter your Email"
        render :forgot_password
     else
        @person = @current_school.people.find_by_email_and_school_id(params[:email], @current_school.id)
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
     @person = @current_school.people.find(params[:id])
     render
  end
  
  def reset_password
    id = params[:id]
    @person = @current_school.people.find(:first, :conditions => ['password_reset_key = ?', id])
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
               flash[:error] = "You should enter Minimum Length"
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
  
  def password_staff
     id = params[:id]
     @staff = @current_school.staff.find(:first, :conditions => ['password_reset_key = ?', id])
     redirect url(:new_staff_password, :id => @staff.id)
  end
  
  def new_staff_password
     @staff = @current_school.staff.find(params[:id])
     render
  end
  
  def staff_password_save
    @staff = @current_school.staff.find(params[:id])
    if ( !params[:staff][:password].blank? ) && (!params[:staff][:password_confirmation].blank? )
         if ( params[:staff][:password] == params[:staff][:password_confirmation] )
            @staff.password = params[:staff][:password]
            @staff.password_confirmation = params[:staff][:password_confirmation]
            if  @staff.save
                redirect url(:login)
            else
               flash[:error] = "You should enter Minimum Length"
               redirect url(:new_staff_password, :id => @staff)
            end
         else
            flash[:error1] = "Your Password doesn't match"
            render :new_staff_password
         end
    else
       flash[:error2] = "Password cant be blank"
       render :new_staff_password
    end
  end
                               
  private
  
  def month_year
     @classrooms = @current_school.classrooms .find(:all)
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
