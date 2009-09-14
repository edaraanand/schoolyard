class Users < Application
   
   before :ensure_authenticated
   layout 'account'
   before :find_school
   before :staff_selected_link, :only => [:staff_account, :staff_account_edit, :staff_password, :staff_account_update]
   
   
  def staff_account
    @person = session.user
    @pic = @current_school.attachments.find(:first, :conditions => ['attachable_type = ? and attachable_id = ? ', "user_picture", @person.id])
    render 
  end
  
  def staff_account_edit
    @person = session.user
    @pic = @current_school.attachments.find(:first, :conditions => ['attachable_type = ? and attachable_id = ? ', "user_picture", @person.id])
    render
  end
  
  def staff_account_update
     @person = session.user
     @content_types = ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
     if params[:person][:image] != ""
        if @content_types.include?(params[:person][:image][:content_type])
            if @person.update_attributes(params[:person])
               @pic = @current_school.attachments.find(:first, :conditions => ['attachable_type = ? and attachable_id = ? ', "user_picture", @person.id])
               unless @pic.nil?
                 @pic.destroy
               end
                f = params[:person][:image][:filename]
                file = File.basename(f.gsub(/\\/, '/'))
               @attachment = Attachment.create( :attachable_type => "user_picture",
                                                :attachable_id => @person.id, 
                                                :filename => file,
                                                :content_type => params[:person][:image][:content_type],
                                                :size => params[:person][:image][:size],
                                                :school_id => @current_school.id
                 )
                File.makedirs("public/uploads/#{@current_school.id}/pictures")
                FileUtils.mv(params[:person][:image][:tempfile].path, "public/uploads/#{@current_school.id}/pictures/#{@attachment.id}")
                redirect url(:staff_account)
           else
               render :staff_account_edit
           end
        else
           flash[:error1] = "You can only upload images"
           render :staff_account_edit
        end
    else
         if @person.update_attributes(params[:person])
            redirect url(:staff_account)
         else
            render :staff_account_edit
         end
    end
  end
  
  def staff_password
    @person = session.user
    render
  end 
  
  def staff_password_update
     @person = session.user
     if  @current_school.people.authenticate(@person.email, @current_school.id, params[:person][:old_password])
      if (( params[:person][:password] == params[:person][:password_confirmation]) && !params[:person][:password_confirmation].blank?)
        if @person.update_attributes(params[:person])
           redirect url(:staff_account)
        else
          flash[:error1] = "You should enter Minimum Length of 8 Characters"
           render :staff_password
        end
      else
        flash[:error2] = "Your Password doesn't match"
        render :staff_password
      end

    else
      flash[:error3] = "Your current password doesn't match existing password"
      render :staff_password
    end
   
  end
  
  
  def parent_account
     @parent = session.user
     @students = @parent.students
     render
  end
  
  def parent_password
     @selected = "parent_profile"
     @parent = session.user
     render
  end
  
  def parent_password_change
    @parent = session.user
    if @current_school.people.authenticate(@parent.email, @current_school.id, params[:parent][:old_password])
        if (( params[:parent][:password] == params[:parent][:password_confirmation]) && !params[:parent][:password_confirmation].blank?)
           if @parent.update_attributes(params[:parent])
              redirect url(:parent_account)
           else
             flash[:error1] = "You should enter Minimum Length of 8 Characters"
              render :parent_password
           end
        else
           flash[:error2] = "Your Password doesn't match"
           render :parent_password
        end
     else
        flash[:error3] = "Your current password doesn't match existing password"
        render :parent_password
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
        redirect url(:parent_account, :label => "other")
     else
        if @parent.update_attributes(params[:parent])
           redirect url(:parent_account)
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
  #    redirect url(:parent_account)
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

  private
  
  def staff_selected_link
     @selected = "staff_profile"
  end
 
end
