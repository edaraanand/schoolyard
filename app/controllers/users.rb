class Users < Application
   
   before :ensure_authenticated
   layout 'account'
   before :find_school
   before :staff_selected_link, :only => [:staff_account_edit, :staff_account_update]
   
  def index
    @person = session.user
    if @person.type == "Staff"
       @staff = session.user
       @pic = @current_school.attachments.find_by_attachable_type_and_attachable_id("user_picture", @staff.id)
    end
    if @person.type == "Parent"
       @parent = session.user
       @students = @parent.students
    end
    @selected = params[:selected]
    render
  end 
  
  def staff_account_edit
    @person = session.user
    @pic = @current_school.attachments.find_by_attachable_type_and_attachable_id("user_picture", @person.id)
    render
  end
  
  def staff_account_update
     @person = session.user
     if @person.update_attributes(params[:person])
        if params[:person][:image] != ""
           @pic = @current_school.attachments.find_by_attachable_type_and_attachable_id("user_picture", @person.id)
           @pic.destroy if @pic
           Attachment.picture(params.merge(:school_id => @current_school.id), "user_picture", @person.id)
        end
        if params[:principal_email] == "on"
           @person.principal_email = true
        else
           @person.principal_email = false
        end
        @person.save
        redirect resource(:users, :selected => "staff_profile")
     else
        render :staff_account_edit
     end
  end
  
  def password
    @selected = params[:selected]
    @person = session.user
    render
  end
  
  def change_password
    @person = session.user
    @selected = params[:selected]
    if @current_school.people.authenticate(@person.email, @current_school.id, params[:person][:old_password])
       if ((params[:person][:password] == params[:person][:password_confirmation]) && 
           !params[:person][:password_confirmation].blank?)
           if @person.update_attributes(params[:person])
              if @person.type == "Staff"
                 redirect resource(:users, :selected => "staff_profile")
              else
                 redirect resource(:users, :selected => "parent_profile")
              end
           else
              flash[:error] = "You should enter Minimum Length of 8 Characters"
              render :password
           end
       else
          flash[:error] = "Your current password doesn't match existing password"
          render :password
       end
    else
       flash[:error] = "Your current password doesn't match existing password"
       render :password
    end
  end
  
  def parent_account_edit
     @parent = session.user
     @students = @parent.students
     render
  end
  
  def add_family
    @array = (1..20).to_a
    if params[:parent]
       @array.each do |f|
          g = f + 4
          if params[:parent][:fname]["fname_#{f}".intern]
            if (params[:parent][:fname]["fname_#{f}".intern] != "" && 
                  params[:parent][:lname]["lname_#{f}".intern] != "" && params[:parent][:email]["email_#{g}".intern] != "")
               fname = params[:parent][:fname]["fname_#{f}".intern]
               lname = params[:parent][:lname]["lname_#{f}".intern]
               email = params[:parent][:email]["email_#{g}".intern]
               @p = @current_school.parents.create({ :first_name => fname, :last_name => lname, :email => email} )
               @students.each do |f|
                  Guardian.create({:student_id => f.id, :parent_id => @p.id })
               end
               @people << @p
            end
          end
       end
    end
    if params[:guardian]
       @array.each do |f|
         if params[:guardian]["first_name_#{f}".intern]
            if (params[:guardian]["first_name_#{f}".intern] != "" && 
                  params[:guardian]["last_name_#{f}".intern] != "" && params[:guardian]["email_#{f}".intern] != "")
               fname = params[:guardian]["first_name_#{f}".intern] 
               lname = params[:guardian]["last_name_#{f}".intern]
               email = params[:guardian]["email_#{f}".intern]
               @students.each do |f|
                  @g = f.parents.delete_if{|x| x.name == @parent.name }.collect{|x| x.id}
               end
               s = fname.zip(lname, email, @g)
               s.each do |t|
                 @current_school.parents.update(t[3], {:first_name => t[0], :last_name => t[1], :email => t[2]})
               end
            end
         end
       end
    end
  end
  
  def parent_update
     @parent = session.user
     @students = @parent.students
     @students.each do |f|
        @guardians = f.parents.delete_if{|x| x.name == @parent.name}
     end  
     @people = []
     if params[:label] == "other"
        @people = []
        add_family
        run_later do
          @people.each do |f|
            f.send_password_approve
          end
        end
        redirect resource(:users, :selected => "parent_profile", :label => "other")
     else
        if @parent.update_attributes(params[:parent])
           redirect resource(:users, :selected => "parent_profile")
        else
           render :parent_account_edit
        end
     end
  end
  
  def student_details
     @selected = "s_details"
     @parent = session.user
     @registrations = @current_school.registrations.find(:all, :conditions => ['parent_id = ?', @parent.id])
     @students = @parent.students
     render
  end
  
  def student_edit
    @selected = "s_details"
    @parent = session.user
    @students = @parent.students
    @classrooms = @current_school.active_classrooms
    render
  end
  
  
  # def student_update
  #    @parent = session.user
  #    @students = @parent.students
  #    @classrooms = @current_school.active_classrooms
  #    student_id = @students.collect{|x| x.id }
  #    redirect resource(:users, :selected => "parent_profile")
  #  end
  
  def phone
    @selected = "phone"
    @person = session.user
    render
  end
  
  def voice_update
    @person = session.user
    @selected = "phone"
    @person.voice_alert = params[:person][:voice_alert]
    @person.sms_alert = params[:person][:sms_alert]
    if @person.valid?                                                                        
       @person.save!
       redirect url(:phone)
    else
       if params[:person][:voice_alert]
          @voice = params[:person][:voice_alert]
          @person.voice_alert = ""
       end
       if params[:person][:sms_alert]
          @sms = params[:person][:sms_alert]
          @person.sms_alert = ""
       end
       render :phone
    end
  end
  
  def subscription
    @person = @current_school.people.find_by_id(params[:id])
    if params[:l] == "sms"
       @person.sms_alert = ""
    else
       @person.voice_alert = ""
    end
    @person.save!
    redirect url(:phone)
  end
  
  def delete
    @person = session.user
    @pic = @current_school.attachments.find_by_attachable_type_and_attachable_id("user_picture", @person.id) rescue NotFound
    @pic.destroy
    redirect resource(:users)
  end

  private
  
  def staff_selected_link
     @selected = "staff_profile"
  end
 
end
