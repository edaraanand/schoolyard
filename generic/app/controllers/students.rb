class Students < Application
  
  layout 'default'
  before :access_rights, :exclude => [:directory, :show]
  before :classrooms, :only => [:directory, :staff]
  before :school_staff, :only => [:staff]
  
  def index 
     @students = Student.find(:all)
     render
  end
  
  def new
     @student = Student.new
     @class_rooms = Classroom.find(:all, :conditions => ['class_type=?', "Classes"])
     @parent = Parent.new
     render
  end
  
  def create
     @class_rooms = Classroom.find(:all, :conditions => ['class_type=?', "Classes"])
     @student = Student.new(params[:student])
     @parent = Parent.new(params[:parent])
     @sp = Parent.find(:first, :conditions => ["first_name = ? and last_name = ?", params[:parent][:first_name], params[:parent][:last_name]])
     if ( ( (params[:f_name_parent2] == "") && (params[:l_name_parent2] == "") ) && (params[:email_parent2] == "") )
        if (@student.valid?) && (@parent.valid?)
          if @sp.nil? 
	           @student.save
	           @parent.save
	           Guardian.create({:student_id => @student.id, :parent_id => @parent.id })
	           Study.create({:student_id => @student.id, :classroom_id => params[:classroom_id] })
	           redirect resource(:students)
           else
             @sp.update_attributes(params[:parent])
             @student.save
	           Guardian.create({:student_id => @student.id, :parent_id => @sp.id })
	           Study.create({:student_id => @student.id, :classroom_id => params[:classroom_id] })
	           redirect resource(:students)
           end
	      else
	         render :new
	      end
     else
	      if @student.valid?
           if @parent.valid?
             if ( ( (params[:f_name_parent2] != "") && (params[:l_name_parent2] != "") ) && (params[:email_parent2] != "") )
                 if ( ( (params[:f_name_parent3] != "") || (params[:l_name_parent3] != "") ) || (params[:email_parent3] != "") )
                   
                    if ( ( (params[:f_name_parent4] !="") || (params[:l_name_parent4] != "") ) || (params[:email_parent4] != "") )
                      
                        if ( ( (params[:f_name_parent4] != "") && (params[:l_name_parent4] != "") ) && (params[:email_parent4] != "") )
                             if @sp.nil? 
                                @student.save
	                              @parent.save
                                Guardian.create({:student_id => @student.id, :parent_id => @parent.id })
	                              Study.create({:student_id => @student.id, :classroom_id => params[:classroom_id] })	
		                            @p = Parent.create({:first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2] })
		                            Guardian.create({:student_id => @student.id, :parent_id => @p.id })
                                @p3 = Parent.create({:first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3] })
                                Guardian.create({:student_id => @student.id, :parent_id => @p3.id })
                                @p4 = Parent.create({:first_name => params[:f_name_parent4], :last_name => params[:l_name_parent4], :email => params[:email_parent4] })
                                Guardian.create({:student_id => @student.id, :parent_id => @p4.id })
                                redirect resource(:students)
                              else
                                @sp.update_attributes(params[:parent])
                                @student.save
	                              Guardian.create({:student_id => @student.id, :parent_id => @sp.id })
	                              Study.create({:student_id => @student.id, :classroom_id => params[:classroom_id] })	
		                            @p = Parent.create({:first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2] })
		                            Guardian.create({:student_id => @student.id, :parent_id => @p.id })
                                @p3 = Parent.create({:first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3] })
                                Guardian.create({:student_id => @student.id, :parent_id => @p3.id })
                                @p4 = Parent.create({:first_name => params[:f_name_parent4], :last_name => params[:l_name_parent4], :email => params[:email_parent4] })
                                Guardian.create({:student_id => @student.id, :parent_id => @p4.id })
                                redirect resource(:students)
                              end  

                        else
                           flash[:error4] = "Please enter the Parent4 details"
                           @fname4 = params[:f_name_parent4]
	                         @lname4 = params[:l_name_parent4]
	                         @mail4 = params[:email_parent4]
	                         @fname3 = params[:f_name_parent3]
	                         @lname3 = params[:l_name_parent3]
	                         @mail3 = params[:email_parent3]
                           @fname2 = params[:f_name_parent2]
	                         @lname2 = params[:l_name_parent2]
	                         @mail2 = params[:email_parent2]
		                       render :new      
                         end
                         
                    else
                        if( ( (params[:f_name_parent3] != "") && (params[:l_name_parent3] != "") ) && (params[:email_parent3] != "") )
                            if @sp.nil?
                               @student.save
	                             @parent.save
                               Guardian.create({:student_id => @student.id, :parent_id => @parent.id })
	                             Study.create({:student_id => @student.id, :classroom_id => params[:classroom_id] })	
		                           @p = Parent.create({:first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2] })
		                           Guardian.create({:student_id => @student.id, :parent_id => @p.id })
                               @p3 = Parent.create({:first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3] })
                               Guardian.create({:student_id => @student.id, :parent_id => @p3.id })
                               redirect resource(:students)
                             else
                               @sp.update_attributes(params[:parent])
                               @student.save
	                             Guardian.create({:student_id => @student.id, :parent_id => @sp.id })
	                             Study.create({:student_id => @student.id, :classroom_id => params[:classroom_id] })	
		                           @p = Parent.create({:first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2] })
		                           Guardian.create({:student_id => @student.id, :parent_id => @p.id })
                               @p3 = Parent.create({:first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3] })
                               Guardian.create({:student_id => @student.id, :parent_id => @p3.id })
                               redirect resource(:students)
                             end
                        else
                           flash[:error3] = "Please enter the Parent3 details"
	                         @fname3 = params[:f_name_parent3]
	                         @lname3 = params[:l_name_parent3]
	                         @mail3 = params[:email_parent3]
                           @fname2 = params[:f_name_parent2]
	                         @lname2 = params[:l_name_parent2]
	                         @mail2 = params[:email_parent2]
		                       render :new
                        end
                     end
                else
                     if @sp.nil?
                        @student.save
	                      @parent.save
                        Guardian.create({:student_id => @student.id, :parent_id => @parent.id })
	                      Study.create({:student_id => @student.id, :classroom_id => params[:classroom_id] })	
		                    @p = Parent.create({:first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2] })
		                    Guardian.create({:student_id => @student.id, :parent_id => @p.id })
                        redirect resource(:students)
                      else
                        @sp.update_attributes(params[:parent])
                        @student.save
	                      Guardian.create({:student_id => @student.id, :parent_id => @sp.id })
	                      Study.create({:student_id => @student.id, :classroom_id => params[:classroom_id] })	
		                    @p = Parent.create({:first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2] })
		                    Guardian.create({:student_id => @student.id, :parent_id => @p.id })
                        redirect resource(:students)
                      end
                end
               
	            else
                flash[:error] = "Please enter the Parent2 details"
	              @fname2 = params[:f_name_parent2]
	              @lname2 = params[:l_name_parent2]
	              @mail2 = params[:email_parent2]
		            render :new
	            end
          else
		         render :new
	        end
       else
	        render :new
	     end
       
     end
     
  end
  
  def edit
     @student = Student.find(params[:id])
     @class_rooms = Classroom.find(:all)
     @sp = @student.parents
     render
  end
  
  def update
     @student = Student.find(params[:id])
     @class_rooms = Classroom.find(:all)
     @sp = @student.parents
     @study_id = Study.find_by_student_id(@student.id)
     parent_id = @sp.collect{|x| x.id }
     sp = params[:parent][:first_name].zip(params[:parent][:last_name], params[:parent][:email], parent_id)
    if @student.update_attributes(params[:student])
        Study.update(@study_id.id, {:student_id => @student.id, :classroom_id => params[:classroom_id]})
     if @sp.length == 1
       if ( ( (params[:f_name_parent2] != "") || (params[:l_name_parent2] != "") ) || (params[:email_parent2] != "") )
           if ( ( (params[:f_name_parent2] != "") && (params[:l_name_parent2] != "") ) && (params[:email_parent2] != "") )
               if( ( (params[:f_name_parent3] != "") || (params[:l_name_parent3] != "") ) || (params[:email_parent3] != "") ) 
                    if( ( (params[:f_name_parent3] != "") && (params[:l_name_parent3] != "") ) && (params[:email_parent3] != "") )
                         if ( ( (params[:f_name_parent4] != "") || (params[:l_name_parent4] != "") ) || (params[:email_parent4] != "") )
                              if ( ( (params[:f_name_parent4] != "") && (params[:l_name_parent4] != "") ) && (params[:email_parent4] != "") )
                                   @a = Parent.create({:first_name => params[:f_name_parent4], :last_name => params[:l_name_parent4], :email => params[:email_parent4] })
                                   Guardian.create({:student_id => @student.id, :parent_id => @a.id })
                                   @b = Parent.create({:first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3] })
                                   Guardian.create({:student_id => @student.id, :parent_id => @b.id })
                                   @c = Parent.create({:first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2] })
                                   Guardian.create({:student_id => @student.id, :parent_id => @c.id })
                                   redirect resource(:students)
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
                                 render :edit
                              end
                         else
                            @b = Parent.create({:first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3] })
                            Guardian.create({:student_id => @student.id, :parent_id => @b.id })
                            @c = Parent.create({:first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2] })
                            Guardian.create({:student_id => @student.id, :parent_id => @c.id })
                            redirect resource(:students)
                         end
                    else
                       flash[:error3] = "Please enter the Parent3 details"
                       @fname3 = params[:f_name_parent3]
	                     @lname3 = params[:l_name_parent3]
	                     @email3 = params[:email_parent3]
                       @fname2 = params[:f_name_parent2]
	                     @lname2 = params[:l_name_parent2]
	                     @email2 = params[:email_parent2]  
                       render :edit
                    end
               else
                   @c = Parent.create({:first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2] })
                   Guardian.create({:student_id => @student.id, :parent_id => @c.id })
                   redirect resource(:students)
               end
           else
               flash[:error2] = "Please enter parent2 details"
               @fname2 = params[:f_name_parent2]
	             @lname2 = params[:l_name_parent2]
	             @email2 = params[:email_parent2]   
               render :edit
           end
       else
           sp.each do |f|
              Parent.update(f[3],{:first_name => f[0], :last_name => f[1], :email => f[2] } )
           end
           redirect resource(:students)
       end
   elsif @sp.length == 2
         if( ( (params[:f_name_parent3] != "") || (params[:l_name_parent3] != "") ) || (params[:email_parent3] != "") ) 
               if( ( (params[:f_name_parent3] != "") && (params[:l_name_parent3] != "") ) && (params[:email_parent3] != "") )
                      if ( ( (params[:f_name_parent4] != "") || (params[:l_name_parent4] != "") ) || (params[:email_parent4] != "") )
                            if ( ( (params[:f_name_parent4] != "") && (params[:l_name_parent4] != "") ) && (params[:email_parent4] != "") )
                                   @a = Parent.create({:first_name => params[:f_name_parent4], :last_name => params[:l_name_parent4], :email => params[:email_parent4] })
                                   Guardian.create({:student_id => @student.id, :parent_id => @a.id })
                                   @b = Parent.create({:first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3] })
                                   Guardian.create({:student_id => @student.id, :parent_id => @b.id })
                                   redirect resource(:students)
                            else
                                 flash[:error4] = "Please enter the Parent4 details"
                                 @fname4 = params[:f_name_parent4]
	                               @lname4 = params[:l_name_parent4]
	                               @email4 = params[:email_parent4]
                                 @fname3 = params[:f_name_parent3]
	                               @lname3 = params[:l_name_parent3]
	                               @email3 = params[:email_parent3]
                                 render :edit
                            end
                      else
                         @b = Parent.create({:first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3] })
                         Guardian.create({:student_id => @student.id, :parent_id => @b.id })
                         redirect resource(:students)
                      end
               else
                   flash[:error3] = "Please enter the Parent3 details"
                   @fname3 = params[:f_name_parent3]
	                 @lname3 = params[:l_name_parent3]
	                 @email3 = params[:email_parent3]
                   render :edit
               end
         else
             sp.each do |f|
                Parent.update(f[3],{:first_name => f[0], :last_name => f[1], :email => f[2] } )
             end
             redirect resource(:students)
         end
    elsif @sp.length == 3
          if ( ( (params[:f_name_parent4] != "") || (params[:l_name_parent4] != "") ) || (params[:email_parent4] != "") )
                if ( ( (params[:f_name_parent4] != "") && (params[:l_name_parent4] != "") ) && (params[:email_parent4] != "") )
                     @c = Parent.create({:first_name => params[:f_name_parent4], :last_name => params[:l_name_parent4], :email => params[:email_parent4] })
                     Guardian.create({:student_id => @student.id, :parent_id => @c.id })
                     redirect resource(:students)
                else
                    flash[:error4] = "Please enter the Parent4 details"
                    @fname4 = params[:f_name_parent4]
	                  @lname4 = params[:l_name_parent4]
	                  @email4 = params[:email_parent4]
                    render :edit
                end
          else
             sp.each do |f|
                Parent.update(f[3],{:first_name => f[0], :last_name => f[1], :email => f[2] } )
             end
             redirect resource(:students)
          end
     elsif @sp.length == 4
          sp.each do |f|
                Parent.update(f[3],{:first_name => f[0], :last_name => f[1], :email => f[2] } )
          end
          redirect resource(:students)
     else
         render :edit
     end
     
   else
      render :edit
   end
   
  end                      
  
  
   def preview
      @first = params[:student][:first_name]
      @last = params[:student][:last_name]
      first = params[:parent][:first_name]
      last = params[:parent][:last_name]
      email = params[:parent][:email]
      @parent = first.zip(last, email)
      render :layout => 'preview'
   end
  
  
   def directory
      @class = Classroom.find_by_class_name(params[:class_name])
      @studs = Student.find(:all, :joins => :studies, :conditions => ["studies.classroom_id = ?", @class.id] )
      if params[:class_name] == "All Students"
         @students = Student.find(:all)
      end
      if params[:class_name].nil?
         @stds = Student.find(:all)
      end
      render :layout => 'directory'
   end
   
   def show
      if params[:label] == "students"
        @student = Student.find(params[:id])
        @parents = @student.parents
      end
      if params[:label] == "staff"
        @staff = Staff.find(params[:id])
      end
      render :layout => 'directory'
   end
   
   def staff
       if params[:class_name] == "All Staff"
          @staff = Staff.find(:all)
       end
       unless params[:class_name].nil?
         unless params[:class_name] == "All Staff"
           @class = Classroom.find_by_class_name(params[:class_name])
           @class_peoples = @class.class_peoples.delete_if{ |x| x.team_id != nil }
         end
       end  
      if params[:class_name].nil?
         @stf = Staff.find(:all)
      end    
      
      render :layout => 'directory'
   end
   
   
   private
   
   def classrooms
      @class = Classroom.find(:all)
      room = @class.collect{|x| x.class_name }
      @classrooms = room.insert(0, "All Students")
   end  
   
   def school_staff
      @class = Classroom.find(:all)
      room = @class.collect{|x| x.class_name }
      @teachers = room.insert(0, "All Staff")
   end
   
   def access_rights
     have_access = false
     @view = Access.find_by_name('view_all')
     @ann = Access.find_by_name('manage_directory')
     @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
     @access_people.each do |f|
       have_access = (f.all == true) || (f.access_id == @ann.id)
       break if have_access
     end
     unless have_access
       redirect resource(:homes)
     end
  end  
  
end
