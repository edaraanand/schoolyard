class Students < Application

  layout 'default'
  before :find_school
  before :access_rights, :exclude => [:generate_csv]

 
  def index
    @students = @current_school.students.paginate(:all, :per_page => 25,  :page => params[:page])
    render
  end

  def new
    @student = Student.new
    @class_rooms = @current_school.active_classrooms
    @protector = Protector.new
    render
  end

  def create
    @class_rooms = @current_school.active_classrooms
    @student = @current_school.students.new(params[:student])
    @protector = @current_school.protectors.new(params[:protector])
    @class = @current_school.classrooms.find_by_class_name(params[:classroom_id])
    if ( ( (params[:f_name_parent2] == "") && (params[:l_name_parent2] == "") ) && (params[:email_parent2] == "") )
      if params[:classroom_id] !=  ""
        if (@student.valid?) && (@protector.valid?)
          @student.activate = true
          @student.save
          @protector.save
          Ancestor.create({:student_id => @student.id, :protector_id => @protector.id })
          Study.create({:student_id => @student.id, :classroom_id => @class.id })
          redirect url(:directory)
        else
          @class_id = params[:classroom_id]
          render :new
        end
      else
        flash[:error] = "Please select option"
        @class_id = params[:classroom_id]
        render :new
      end
    else
      if (@student.valid?) && (@protector.valid?)
        if ( ( (params[:f_name_parent2] != "") && (params[:l_name_parent2] != "") ) && (params[:email_parent2] != "") )
          if ( ( (params[:f_name_parent3] != "") || (params[:l_name_parent3] != "") ) || (params[:email_parent3] != "") )
            if ( ( (params[:f_name_parent4] !="") || (params[:l_name_parent4] != "") ) || (params[:email_parent4] != "") )
              if ( ( (params[:f_name_parent4] != "") && (params[:l_name_parent4] != "") ) && (params[:email_parent4] != "") )
                @student.save
                @protector.save
                Ancestor.create({:student_id => @student.id, :parent_id => @protector.id })
                Study.create({:student_id => @student.id, :classroom_id => params[:classroom_id] })
                @p2 = @current_school.protectors.create({:first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2] })
                Ancestor.create({:student_id => @student.id, :protector_id => @p2.id })
                @p3 = @current_school.protectors.create({:first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3] })
                Ancestor.create({:student_id => @student.id, :protector_id => @p3.id })
                @p4 = @current_school.protectors.create({:first_name => params[:f_name_parent4], :last_name => params[:l_name_parent4], :email => params[:email_parent4] })
                Ancestor.create({:student_id => @student.id, :protector_id => @p4.id })
                redirect url(:directory)
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
                @class_id = params[:classroom_id]
                render :new
              end
            else
              if( ( (params[:f_name_parent3] != "") && (params[:l_name_parent3] != "") ) && (params[:email_parent3] != "") )
                @student.save
                @protector.save
                Ancestor.create({:student_id => @student.id, :protector_id => @protector.id })
                Study.create({:student_id => @student.id, :classroom_id => params[:classroom_id] })
                @p2 = @current_school.protectors.create({:first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2] })
                Ancestor.create({:student_id => @student.id, :protector_id => @p2.id })
                @p3 = @current_school.protectors.create({:first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3] })
                Ancestor.create({:student_id => @student.id, :protector_id => @p3.id })
                redirect url(:directory)
              else
                flash[:error3] = "Please enter the Parent3 details"
                @fname3 = params[:f_name_parent3]
                @lname3 = params[:l_name_parent3]
                @mail3 = params[:email_parent3]
                @fname2 = params[:f_name_parent2]
                @lname2 = params[:l_name_parent2]
                @mail2 = params[:email_parent2]
                @class_id = params[:classroom_id]
                render :new
              end
            end
          else
            @student.save
            @protector.save
            Ancestor.create({:student_id => @student.id, :protector_id => @protector.id })
            Study.create({:student_id => @student.id, :classroom_id => params[:classroom_id] })
            @p2 = @current_school.protectors.create({:first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2] })
            Ancestor.create({:student_id => @student.id, :protector_id => @p2.id })
            redirect url(:directory)
          end

        else
          flash[:error] = "Please enter the Parent2 details"
          @fname2 = params[:f_name_parent2]
          @lname2 = params[:l_name_parent2]
          @mail2 = params[:email_parent2]
          @class_id = params[:classroom_id]
          render :new
        end
      else
        render :new
      end
    end

  end

  def edit
    @student = @current_school.students.find(params[:id])
    @class_rooms = @current_school.active_classrooms
    @sp = @student.protectors
    @student_class = @student.studies
    render
  end

  def update
    @student = @current_school.students.find(params[:id])
    @class_rooms = @current_school.active_classrooms
    @sp = @student.protectors
    @student_class = @student.studies
    @study_id = Study.find_by_student_id(@student.id)
    @class = @current_school.classrooms.find_by_class_name(params[:classroom_id])
    protector_id = @sp.collect{|x| x.id }
    sp = params[:parent][:first_name].zip(params[:parent][:last_name], params[:parent][:email], protector_id)
    if @student.update_attributes(params[:student])
      @student.activate = true
      @student.save
      Study.update(@study_id.id, {:student_id => @student.id, :classroom_id => @class.id })
      if @sp.length == 1
        if ( ( (params[:f_name_parent2] != "") || (params[:l_name_parent2] != "") ) || (params[:email_parent2] != "") )
          if ( ( (params[:f_name_parent2] != "") && (params[:l_name_parent2] != "") ) && (params[:email_parent2] != "") )
            if( ( (params[:f_name_parent3] != "") || (params[:l_name_parent3] != "") ) || (params[:email_parent3] != "") )
              if( ( (params[:f_name_parent3] != "") && (params[:l_name_parent3] != "") ) && (params[:email_parent3] != "") )
                if ( ( (params[:f_name_parent4] != "") || (params[:l_name_parent4] != "") ) || (params[:email_parent4] != "") )
                  if ( ( (params[:f_name_parent4] != "") && (params[:l_name_parent4] != "") ) && (params[:email_parent4] != "") )
                    @p2 = @current_school.protectors.create({:first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2] })
                    Ancestor.create({:student_id => @student.id, :protector_id => @p2.id })
                    @p3 = @current_school.protectors.create({:first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3] })
                    Ancestor.create({:student_id => @student.id, :protector_id => @p3.id })
                    @p4 = @current_school.protectors.create({:first_name => params[:f_name_parent4], :last_name => params[:l_name_parent4], :email => params[:email_parent4] })
                    Ancestor.create({:student_id => @student.id, :protector_id => @p4.id })
                    redirect url(:directory)
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
                  @p2 = @current_school.protectors.create({:first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2] })
                  Ancestor.create({:student_id => @student.id, :protector_id => @p2.id })
                  @p3 = @current_school.protectors.create({:first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3] })
                  Ancestor.create({:student_id => @student.id, :protector_id => @p3.id })
                  redirect url(:directory)
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
              @p2 = @current_school.protectors.create({:first_name => params[:f_name_parent2], :last_name => params[:l_name_parent2], :email => params[:email_parent2] })
              Ancestor.create({:student_id => @student.id, :protector_id => @p2.id })
              redirect url(:directory)
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
            @current_school.protectors.update(f[3],{:first_name => f[0], :last_name => f[1], :email => f[2] } )
          end
          redirect url(:directory)
        end
      elsif @sp.length == 2
        if( ( (params[:f_name_parent3] != "") || (params[:l_name_parent3] != "") ) || (params[:email_parent3] != "") )
          if( ( (params[:f_name_parent3] != "") && (params[:l_name_parent3] != "") ) && (params[:email_parent3] != "") )
            if ( ( (params[:f_name_parent4] != "") || (params[:l_name_parent4] != "") ) || (params[:email_parent4] != "") )
              if ( ( (params[:f_name_parent4] != "") && (params[:l_name_parent4] != "") ) && (params[:email_parent4] != "") )
                @p3 = @current_school.protectors.create({:first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3] })
                Ancestor.create({:student_id => @student.id, :protector_id => @p3.id })
                @p4 = @current_school.protectors.create({:first_name => params[:f_name_parent4], :last_name => params[:l_name_parent4], :email => params[:email_parent4] })
                Ancestor.create({:student_id => @student.id, :protector_id => @p4.id })
                redirect url(:directory)
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
              @p3 = @current_school.protectors.create({:first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3] })
              Ancestor.create({:student_id => @student.id, :protector_id => @p3.id })
              redirect url(:directory)
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
            @current_school.protectors.update(f[3],{:first_name => f[0], :last_name => f[1], :email => f[2] } )
          end
          redirect url(:directory)
        end
      elsif @sp.length == 3
        if ( ( (params[:f_name_parent4] != "") || (params[:l_name_parent4] != "") ) || (params[:email_parent4] != "") )
          if ( ( (params[:f_name_parent4] != "") && (params[:l_name_parent4] != "") ) && (params[:email_parent4] != "") )
            @p4 = @current_school.protectors.create({:first_name => params[:f_name_parent4], :last_name => params[:l_name_parent4], :email => params[:email_parent4] })
            Ancestor.create({:student_id => @student.id, :protector_id => @p4.id })
            redirect url(:directory)
          else
            flash[:error4] = "Please enter the Parent4 details"
            @fname4 = params[:f_name_parent4]
            @lname4 = params[:l_name_parent4]
            @email4 = params[:email_parent4]
            render :edit
          end
        else
          sp.each do |f|
            @current_school.protectors.update(f[3],{:first_name => f[0], :last_name => f[1], :email => f[2] } )
          end
          redirect url(:directory)
        end
      elsif @sp.length == 4
        sp.each do |f|
          @current_school.protectors.update(f[3],{:first_name => f[0], :last_name => f[1], :email => f[2] } )
        end
        redirect url(:directory)
      else
        render :edit
      end

    else
      render :edit
    end

  end


  def preview
     @selected = "students"
    if params[:_method] == "put"
      first = params[:student][:first_name]
      last = params[:student][:last_name]
      @student = @current_school.students.find(:first, :conditions => ["first_name = ? and last_name = ?", first, last ])
      @parents = @student.protectors
   else
      first = params[:protector][:first_name]
      last = params[:protector][:last_name]
      email = params[:protector][:email]
      @parent = first.zip(last, email)
    end
    render :layout => 'preview'
  end


  def activation
     @student = @current_school.students.find_by_id(params[:id])
     raise NotFound unless @student
     @parents = @student.parents
     if params[:label] == "deactivate"
        guardian = Guardian.find_by_student_id(@student.id)
        g = Guardian.find(:all, :conditions => ["parent_id = ? and student_id != ?", guardian.parent_id, @student.id ])
        if g.empty?
           @parents.each do |f|
              f.activate = false
              f.save
           end
        end
        @student.activate = false
        @student.save
     else
        @student.activate = true
        @parents.each do |f|
          f.activate = true
          f.save
        end
        @student.save
     end
     redirect resource(:students)
  end
 

  private

  def access_rights
    @selected = "students"
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
