class Users < Application
   
   before :ensure_authenticated
   layout 'account'
   
  def staff_account
    @person = session.user
    render 
  end
  
  def staff_account_edit
    @person = session.user
    render
  end
  
  def staff_account_update
    @person = session.user
    if @person.update_attributes(params[:person])
      redirect url(:staff_account)
    else
      render :staff_account_edit
    end
  end
  
  def staff_password
    @person = session.user
    render
  end 
  
  def staff_password_update
     @person = session.user
    if  Person.authenticate(@person.email, params[:person][:old_password])
      if (( params[:person][:password] == params[:person][:password_confirmation]) && !params[:person][:password_confirmation].blank?)
        if @person.update_attributes(params[:person])
          redirect url(:staff_account)
        else
          flash[:error1] = "Your Password is not updated"
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
     @parent = session.user
     render
  end
  
  def parent_password_change
    @parent = session.user
    if  Person.authenticate(@parent.email, params[:parent][:old_password])
        if (( params[:parent][:password] == params[:parent][:password_confirmation]) && !params[:parent][:password_confirmation].blank?)
           if @parent.update_attributes(params[:parent])
              redirect url(:parent_account)
           else
              flash[:error1] = "Your Password is not updated"
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
  
  def parent_update
     @parent = session.user
     @students = @parent.students
     @students.each do |f|
       @guardians = f.parents.delete_if{|x| x.name == @parent.name}
     end  
    if params[:label] == "other"
       guardian_id = @guardians.collect{|x| x.id }
       unless params[:guardian].nil?
          sp =  params[:guardian][:first_name].zip(params[:guardian][:last_name], params[:guardian][:email], guardian_id)
       end
       if @guardians.length == 0
           if ( ( (params[:f_name_parent2] != "") || (params[:l_name_parent2] != "") ) || (params[:email_parent2] != "") )
                if ( ( (params[:f_name_parent2] != "") && (params[:l_name_parent2] != "") ) && (params[:email_parent2] != "") )
                     if( ( (params[:f_name_parent3] != "") || (params[:l_name_parent3] != "") ) || (params[:email_parent3] != "") ) 
                          if( ( (params[:f_name_parent3] != "") && (params[:l_name_parent3] != "") ) && (params[:email_parent3] != "") )
                              if ( ( (params[:f_name_parent4] != "") || (params[:l_name_parent4] != "") ) || (params[:email_parent4] != "") )
                                   if ( ( (params[:f_name_parent4] != "") && (params[:l_name_parent4] != "") ) && (params[:email_parent4] != "") )
                                       @p2 = Parent.create({ :first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2]} )
                                       @p3 = Parent.create({ :first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3]} )
                                       @p4 = Parent.create({ :first_name => params[:f_name_parent4], :last_name => params[:l_name_parent4], :email => params[:email_parent4]} )
                                       @students.each do |f|
                                          Guardian.create({:student_id => "#{f.id}" , :parent_id => @p2.id })
                                       end
                                       @students.each do |f|
                                          Guardian.create({:student_id => "#{f.id}" , :parent_id => @p3.id })
                                       end
                                       @students.each do |f|
                                          Guardian.create({:student_id => "#{f.id}" , :parent_id => @p4.id })
                                       end
                                       @p2.send_password_approve
                                       @p3.send_password_approve
                                       @p4.send_password_approve
                                       redirect url(:parent_account, :label => "other")
                                   else
                                       flash[:error4] = "Please enter the Parent4 details"
                                       @fname4 = params[:f_name_parent4]
	                                     @lname4 = params[:l_name_parent4]
	                                     @email4 = params[:email_parent4]
                                       @fname3 = params[:f_name_parent3]
	                                     @lname3 = params[:l_name_parent3]
	                                     @email3 = params[:email_parent3]
                                       @fname2 = params[:f_name_parent2]
	                                     @lname2 = params[:l_name_parent2]
	                                     @email2 = params[:email_parent2]  
                                       render :parent_account_edit, :label => "other"
                                     end
                              else
                                  @p2 = Parent.create({ :first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2]} )
                                  @p3 = Parent.create({ :first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3]} )
                                  @students.each do |f|
                                     Guardian.create({:student_id => "#{f.id}" , :parent_id => @p2.id })
                                  end
                                  @students.each do |f|
                                     Guardian.create({:student_id => "#{f.id}" , :parent_id => @p3.id })
                                  end
                                   @p2.send_password_approve
                                   @p3.send_password_approve
                                  redirect url(:parent_account, :label => "other")
                              end
                          else
                               flash[:error3] = "Please enter the Parent3 details"
                               @fname3 = params[:f_name_parent3]
	                             @lname3 = params[:l_name_parent3]
	                             @email3 = params[:email_parent3]
                               @fname2 = params[:f_name_parent2]
	                             @lname2 = params[:l_name_parent2]
	                             @email2 = params[:email_parent2]  
                               render :parent_account_edit, :label => "other"
                           end
                     else
                         @p2 = Parent.create({ :first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2]} )
                         @students.each do |f|
                           Guardian.create({:student_id => "#{f.id}" , :parent_id => @p2.id })
                         end
                          @p2.send_password_approve
                          redirect url(:parent_account, :label => "other")
                     end
                 else
                     flash[:error2] = "Please enter the Parent2 details"
                     @fname2 = params[:f_name_parent2]
	                   @lname2 = params[:l_name_parent2]
	                   @email2 = params[:email_parent2]  
                     render :parent_account_edit, :label => "other"
                 end
            else
                redirect url(:parent_account, :label => "other")
            end
       elsif @guardians.length == 1
               if( ( (params[:f_name_parent3] != "") || (params[:l_name_parent3] != "") ) || (params[:email_parent3] != "") ) 
                     if( ( (params[:f_name_parent3] != "") && (params[:l_name_parent3] != "") ) && (params[:email_parent3] != "") )
                           if ( ( (params[:f_name_parent4] != "") || (params[:l_name_parent4] != "") ) || (params[:email_parent4] != "") )
                                 if ( ( (params[:f_name_parent4] != "") && (params[:l_name_parent4] != "") ) && (params[:email_parent4] != "") )
                                       @p3 = Parent.create({ :first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3]} )
                                       @p4 = Parent.create({ :first_name => params[:f_name_parent4], :last_name => params[:l_name_parent4], :email => params[:email_parent4]} )
                                       @students.each do |f|
                                          Guardian.create({:student_id => "#{f.id}" , :parent_id => @p3.id })
                                       end
                                       @students.each do |f|
                                          Guardian.create({:student_id => "#{f.id}" , :parent_id => @p4.id })
                                       end
                                       @p3.send_password_approve
                                       @p4.send_password_approve
                                       redirect url(:parent_account, :label => "other")
                                 else
                                       flash[:error4] = "Please enter the Parent4 details"
                                       @fname4 = params[:f_name_parent4]
	                                     @lname4 = params[:l_name_parent4]
	                                     @email4 = params[:email_parent4]
                                       @fname3 = params[:f_name_parent3]
	                                     @lname3 = params[:l_name_parent3]
	                                     @email3 = params[:email_parent3]
                                       render :parent_account_edit, :label => "other"
                                  end
                            else
                                @p3 = Parent.create({ :first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3]} )
                                @students.each do |f|
                                     Guardian.create({:student_id => "#{f.id}" , :parent_id => @p3.id })
                                end
                                @p3.send_password_approve
                                redirect url(:parent_account, :label => "other")
                            end
                     else
                         flash[:error3] = "Please enter the Parent3 details"
                         @fname3 = params[:f_name_parent3]
	                       @lname3 = params[:l_name_parent3]
	                       @email3 = params[:email_parent3]
                         render :parent_account_edit, :label => "other"
                     end
               else
                    sp.each do |f|
                       Parent.update(f[3],{:first_name => f[0], :last_name => f[1], :email => f[2] } )
                    end
                    redirect url(:parent_account, :label => "other")
               end
        elsif @guardians.length == 2
             if ( ( (params[:f_name_parent4] != "") || (params[:l_name_parent4] != "") ) || (params[:email_parent4] != "") )
                     if ( ( (params[:f_name_parent4] != "") && (params[:l_name_parent4] != "") ) && (params[:email_parent4] != "") )
                            @p4 = Parent.create({ :first_name => params[:f_name_parent4], :last_name => params[:l_name_parent4], :email => params[:email_parent4]} )
                            @students.each do |f|
                                Guardian.create({:student_id => "#{f.id}" , :parent_id => @p4.id })
                            end 
                            @p4.send_password_approve
                            redirect url(:parent_account, :label => "other")
                     else
                          flash[:error4] = "Please enter the Parent4 details"
                          @fname4 = params[:f_name_parent4]
	                        @lname4 = params[:l_name_parent4]
	                        @email4 = params[:email_parent4]
                          @fname3 = params[:f_name_parent3]
	                        @lname3 = params[:l_name_parent3]
	                        @email3 = params[:email_parent3]
                          render :parent_account_edit, :label => "other"
                     end
             else
                 sp.each do |f|
                     Parent.update(f[3],{:first_name => f[0], :last_name => f[1], :email => f[2] } )
                 end
                 redirect url(:parent_account, :label => "other")
             end
        elsif @guardians.length == 3
              sp.each do |f|
                 Parent.update(f[3],{:first_name => f[0], :last_name => f[1], :email => f[2] } )
              end
              redirect url(:parent_account, :label => "other")
        else
            render :parent_account_edit, :label => "other"
        end  
    
   else
      if @parent.update_attributes(params[:parent])
         redirect url(:parent_account)
      else
         render :parent_account_edit
      end
    end
   
  end
  
  def student_details
     @parent = session.user
     @students = @parent.students
     render
  end
  
  def student_edit
    @parent = session.user
    @students = @parent.students
    @classrooms = Classroom.find(:all)
    render
  end
  
  
  def student_update
    @parent = session.user
    @students = @parent.students
    @classrooms = Classroom.find(:all)
    student_id = @students.collect{|x| x.id }
    sp = params[:classroom_id].zip(student_id)
    if @students.length == 1
         if ( ( (params[:f_name_student2] != "") || (params[:l_name_student2] != "") ) ||  ( (params[:current_class2] != "") ||  (params[:birth_date2] != "") ) )
              if ( ( (params[:f_name_student2] != "") && (params[:l_name_student2] != "") ) &&  ( (params[:current_class2] != "") &&  (params[:birth_date2] != "") ) )
                   if ( ( (params[:f_name_student3] != "") || (params[:l_name_student3] != "") ) || (params[:current_class3] != "") )
                        if ( ( (params[:f_name_student3] != "") && (params[:l_name_student3] != "") ) &&  ( (params[:current_class3] != "") &&  (params[:birth_date3] != "") ) )
                             if ( ( (params[:f_name_student4] !="") || (params[:l_name_student4] != "") ) || (params[:current_class4] != "") )
                                  if ( ( (params[:f_name_student4] != "") && (params[:l_name_student4] != "") ) &&  ( (params[:current_class4] != "") &&  (params[:birth_date4] != "") ) )
                                       Registration.create({ :first_name => params[:f_name_student2], :last_name => params[:l_name_student2], :birth_date => params[:birth_date2], :current_class => params[:current_class2], :parent_id => @parent.id } )                               
                                       Registration.create({:first_name => params[:f_name_student3], :last_name => params[:l_name_student3], :birth_date => params[:birth_date3], :current_class => params[:current_class3], :parent_id => @parent.id  })                                 
                                       Registration.create({:first_name => params[:f_name_student4], :last_name => params[:l_name_student4], :birth_date => params[:birth_date4], :current_class => params[:current_class4], :parent_id => @parent.id  })
                                       @parent.approved = 2
                                       @parent.save
                                       redirect url(:student_details)
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
                                      render :student_edit
                                  end
                             else
                                 Registration.create({ :first_name => params[:f_name_student2], :last_name => params[:l_name_student2], :birth_date => params[:birth_date2], :current_class => params[:current_class2], :parent_id => @parent.id } )                               
                                 Registration.create({:first_name => params[:f_name_student3], :last_name => params[:l_name_student3], :birth_date => params[:birth_date3], :current_class => params[:current_class3], :parent_id => @parent.id  })                                 
                                 @parent.approved = 2
                                 @parent.save
                                 redirect url(:student_details)
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
                             render :student_edit
                         end
                  else
                      Registration.create({ :first_name => params[:f_name_student2], :last_name => params[:l_name_student2], :birth_date => params[:birth_date2], :current_class => params[:current_class2], :parent_id => @parent.id } )
                      @parent.approved = 2
                      @parent.save
                      redirect url(:student_details)
                  end
             else     
                flash[:error2] = "Please enter the Student2 details"
                @fname2 = params[:f_name_student2]
	              @lname2 = params[:l_name_student2]
	              @current_class2 = params[:current_class2]
                @birth_date2 = params[:birth_date2]
                render :student_edit
             end  
         else
             sp.each do |f|
                 @study_id = Study.find_by_student_id(f[1])
                 Study.update(@study_id.id, {:student_id => f[1], :classroom_id => params[:classroom_id]})
             end
             redirect url(:student_details)
         end
      elsif @students.length == 2
               if ( ( (params[:f_name_student3] != "") || (params[:l_name_student3] != "") ) || (params[:current_class3] != "") )
                    if ( ( (params[:f_name_student3] != "") && (params[:l_name_student3] != "") ) &&  ( (params[:current_class3] != "") &&  (params[:birth_date3] != "") ) )
                          if ( ( (params[:f_name_student4] !="") || (params[:l_name_student4] != "") ) || (params[:current_class4] != "") )
                               if ( ( (params[:f_name_student4] != "") && (params[:l_name_student4] != "") ) &&  ( (params[:current_class4] != "") &&  (params[:birth_date4] != "") ) )
                                    Registration.create({:first_name => params[:f_name_student3], :last_name => params[:l_name_student3], :birth_date => params[:birth_date3], :current_class => params[:current_class3], :parent_id => @parent.id  })                                 
                                    Registration.create({:first_name => params[:f_name_student4], :last_name => params[:l_name_student4], :birth_date => params[:birth_date4], :current_class => params[:current_class4], :parent_id => @parent.id  })
                                    @parent.approved = 2
                                    @parent.save
                                    redirect url(:student_details)
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
                               end
                           else
                               Registration.create({:first_name => params[:f_name_student3], :last_name => params[:l_name_student3], :birth_date => params[:birth_date3], :current_class => params[:current_class3], :parent_id => @parent.id  })                                 
                               @parent.approved = 2
                               @parent.save
                               redirect url(:student_details)
                           end
                     else
                          flash[:error3] = "Please enter the Student3 details"
                          @fname3 = params[:f_name_student3]
	                        @lname3 = params[:l_name_student3]
	                        @current_class3 = params[:current_class3]
                          @birth_date3 = params[:birth_date3]
                     end
               else
                    sp.each do |f|
                       @study_id = Study.find_by_student_id(f[1])
                       Study.update(@study_id.id, {:student_id => f[1], :classroom_id => params[:classroom_id]})
                    end
               end
      elsif @students.length == 3   
              if ( ( (params[:f_name_student4] !="") || (params[:l_name_student4] != "") ) || (params[:current_class4] != "") )
                    if ( ( (params[:f_name_student4] != "") && (params[:l_name_student4] != "") ) &&  ( (params[:current_class4] != "") &&  (params[:birth_date4] != "") ) )
                        Registration.create({:first_name => params[:f_name_student4], :last_name => params[:l_name_student4], :birth_date => params[:birth_date4], :current_class => params[:current_class4], :parent_id => @parent.id  })
                        @parent.approved = 2
                        @parent.save
                        redirect url(:student_details)
                    else
                        flash[:error4] = "Please enter the Student4 details"
                        @fname4 = params[:f_name_student4]
	                      @lname4 = params[:l_name_student4]
	                      @current_class4 = params[:current_class4]
                        @birth_date4 = params[:birth_date4]
                    end
              else
                    sp.each do |f|
                       @study_id = Study.find_by_student_id(f[1])
                       Study.update(@study_id.id, {:student_id => f[1], :classroom_id => params[:classroom_id]})
                    end                
              end     
      elsif @students.length == 4
             sp.each do |f|
                 @study_id = Study.find_by_student_id(f[1])
                 Study.update(@study_id.id, {:student_id => f[1], :classroom_id => params[:classroom_id]})
             end 
      else
          render :student_details
      end
                  
  end
  
 
  
  
  
  
  
  
end
