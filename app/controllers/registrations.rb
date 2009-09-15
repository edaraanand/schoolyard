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
    @parent = @current_school.parents.new(params[:parent].merge(:activate => false))
    @registration = @current_school.registrations.new(params[:registration])
    if ( ( (params[:f_name_student2] == "") && (params[:l_name_student2] == "") ) &&  ( (params[:current_class2] == "") &&  (params[:birth_date2] == "") ) )
      if (@parent.valid?) && (@registration.valid?)
        @parent.save
        @registration.parent_id = @parent.id
        @registration.save
        @parent.sign_up_verification
        redirect url(:registration_process, :l => @parent.password_reset_key)
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
                  @parent.sign_up_verification
                  redirect url(:registration_process, :l => @parent.password_reset_key)
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
                  @parent.sign_up_verification
                  redirect url(:registration_process, :l => @parent.password_reset_key)
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
              @parent.sign_up_verification
              redirect url(:registration_process, :l => @parent.password_reset_key)
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
    id = params[:l]
    @parent = @current_school.parents.find(:first, :conditions => ['password_reset_key = ?', id])
    if @parent
       render
    else
       flash[:success] = "Your Approval has been sent to School"
       redirect url(:login)
    end
  end
 
  def registration_last
    id = params[:id]
    @parent = @current_school.parents.find(:first, :conditions => ['password_reset_key = ?', id])
    if @parent
       @parent.approved = 2
       @parent.password_reset_key = nil
       @parent.save!
       render
    else
       flash[:success] = "Your Approval has been sent to School"
       redirect url(:login)
    end
  end
 
  def new_password
    id = params[:id]
    @parent = @current_school.parents.find_by_password_reset_key(id)
    if @parent
       render
    else
       flash[:success] = "Your password has been saved. please enter your mail-ID and password to start using SchoolYard"
       redirect url(:login)
    end
  end
 
  def password_save
    id = params[:id]
    @parent = @current_school.parents.find_by_password_reset_key(id)
    if ( !params[:parent][:password].blank? ) && (!params[:parent][:password_confirmation].blank? )
      if ( params[:parent][:password] == params[:parent][:password_confirmation] )
         @parent.password = params[:parent][:password]
         @parent.password_confirmation = params[:parent][:password_confirmation]
         @parent.school_id = @current_school.id
         if @parent.save
            @parent.reset
            session.user = @parent
            flash[:success] = "Your password has been saved. please enter your mail-ID and password to start using SchoolYard"
            redirect '/'
         else
           flash[:error] = "You should enter Minimum Length of 8 Characters"
           redirect url(:new_password, :id => @parent.password_reset_key)
         end
      else
        flash[:error] = "Your Password doesn't match"
        redirect url(:new_password, :id => @parent.password_reset_key)
      end
    else
      flash[:error] = "Password cant be blank"
      redirect url(:new_password, :id => @parent.password_reset_key)
    end
  end
 
  def forgot_password
    render :layout => 'login'
  end
 
  def get_password
    if params[:email] == ""
      flash[:error] = "Please Enter your Email"
      render :forgot_password, :layout => 'login'
    else
      @person = @current_school.people.find_by_email_and_school_id(params[:email], @current_school.id)
      if @person.nil?
        flash[:error] = "You should enter correct Email that you have provided for the school"
        render :forgot_password, :layout => 'login'
      else
        @person.reset_password
        redirect url(:password_sent, :id => @person.password_reset_key)
      end
    end
  end
 
  def password_sent
    id = params[:id]
    @person = @current_school.people.find_by_password_reset_key(params[:id])
    render :layout => 'login'
  end
 
  def reset_password_edit
    id = params[:id]
    @person = @current_school.people.find_by_password_reset_key(id)
    if @person
       render :layout => 'login'
    else
       flash[:success] = "Your password has been saved. please enter your mail-ID and password to start using SchoolYard"
       redirect url(:login)
    end
  end
 
  def reset_password_update
    @person = @current_school.people.find_by_password_reset_key(params[:id])
    if ( !params[:person][:password].blank? ) 
      if ( params[:person][:password] == params[:person][:password_confirmation] )
        @person.password = params[:person][:password]
        @person.password_confirmation = params[:person][:password_confirmation]
        if @person.save!
           @person.resetting
           session.user = @person
           flash[:success] = "Your password has been saved. please enter your mail-ID and password to start using SchoolYard"
           redirect '/'
        else
           flash[:error] = "You should enter Minimum Length of 8 Characters"
           redirect url(:reset_password_edit, :id => @person.password_reset_key)
        end
      else
        flash[:error] = "Your Password doesn't match"
        redirect url(:reset_password_edit, :id => @person.password_reset_key )
      end
    else
      flash[:error] = "Password cant be blank"
      redirect url(:reset_password_edit, :id => @person.password_reset_key )
    end
  end
 
  def new_staff_password
    id = params[:id]
    @person = @current_school.people.find_by_password_reset_key(params[:id])
    if @person
       render :layout => 'login'
    else
       flash[:success] = "Your password has been saved. please enter your mail-ID and password to start using SchoolYard"
       redirect url(:login)
       #raise NotFound
    end
  end
 
  def staff_password_save
    id = params[:id]
    @person = @current_school.people.find_by_password_reset_key(params[:id])
    if @person
        if ( !params[:person][:password].blank? ) 
          if ( params[:person][:password] == params[:person][:password_confirmation] )
             @person.password = params[:person][:password]
             @person.password_confirmation = params[:person][:password_confirmation]
             if @person.save
                @person.resetting
                session.user = @person
                flash[:success] = "Your password has been saved. please enter your mail-ID and password to start using SchoolYard"
                redirect '/'
             else
                flash[:error] = "You should enter Minimum Length of 8 Characters"
                redirect url(:new_staff_password, :id => @person.password_reset_key)
             end
          else
            flash[:error] = "Your Password doesn't match"
            render :new_staff_password, :id => @person.password_reset_key, :layout => 'login'
          end
        else
           flash[:error] = "Password cant be blank"
           render :new_staff_password, :id => @person.password_reset_key, :layout => 'login'
        end
    else
       raise BadRequest
    end
  end
 
  private
 
  def month_year
    @classrooms = @current_school.active_classrooms
    @years = (1999..2020).to_a
    @months = [ 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
  end
 
 
 
end