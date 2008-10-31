class Students < Application

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
     @parent = @student.parents.build(params[:parent])
     unless params[:sp].nil?
        s = params[:sp][:first].zip(params[:sp][:last], params[:sp][:mail])
	      s.each do |p|
	         @p = @student.parents.build({ :first_name => p[0], :last_name => p[1], :email => p[2] }) 
        end  
     end
    
     if @student.save
	      Study.create({:student_id => @student.id, :classroom_id => params[:classroom_id] })
       	redirect resource(:students)
     else
	      render :new
     end
  end
  
  def edit
     @student = Student.find(params[:id])
     @class_rooms = Classroom.find(:all)
     render
  end
  
  def update
    # @parent = Parent.new
     @class_rooms = Classroom.find(:all)
     @student = Student.find(params[:id])
     @study_id = Study.find_by_student_id(@student.id)
     @student.attributes = params[:student]
      phone = params[:parent][:phone]
      address = params[:parent][:address]
      parents = @student.parents
      parent_id =  parents.collect{|x| x.id }
      s = params[:parent][:first_name].zip(params[:parent][:last_name], params[:parent][:email], parent_id)
           s.each do |s|
              if s[3].nil?
	         @student.parents << @student.parents.build({:first_name => s[0], :last_name => s[1], :email => s[2], :phone => "#{phone}", :address => "#{address}" })
              else   
	      @p =  Parent.update(s[3],{:first_name => s[0], :last_name => s[1], :email => s[2], :phone => "#{phone}", :address => "#{address}" } )
	      end
           end
       if @student.valid? 
	   if @p.valid?
              @student.save
	      Study.update(@study_id.id, {:student_id => @student.id, :classroom_id => params[:classroom_id]})
	      redirect resource(:students)
           else
	      flash[:error1] = "Please enter the Parent details"
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
  
  
  
end
