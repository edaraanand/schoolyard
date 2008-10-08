class Students < Application

  def index 
     @students = Student.find(:all)
    render
  end
  
  def new
     @student = Student.new
     @class_rooms = Classroom.find(:all)
     render
  end
  
  def create
     first = params[:parent][:first_name]
     last = params[:parent][:last_name]
     email = params[:parent][:email]
     @student = Student.create(params[:student])
     @study = Study.create({:student_id => @student.id, :classroom_id => params[:classroom_id]})
     s = first.zip(last, email)
     @guardians = []
       s.each do |p|
	  @parent = Parent.create({:first_name => p[0], :last_name => p[1], :email => p[2],
		            :phone => params[:parent][:phone], :address => params[:parent][:address]  })
	   @guardians << Guardian.create({:parent_id => @parent.id, :student_id => @student.id } )
       end
     redirect url(:students)
  end
  
  def edit
     @student = Student.find(params[:id])
     @class_rooms = Classroom.find(:all)
     @parents = @student.parents
     render
  end
  
  def update
     @student = Student.find(params[:id])
     first = params[:parent][:first_name]
     last = params[:parent][:last_name]
     email = params[:parent][:email]
     @student.update_attributes(params[:student])
     @study_id = Study.find_by_student_id(@student.id)
     @studies = Study.update(@study_id.id, {:student_id => @student.id, :classroom_id => params[:classroom_id]})
     @stu = @student.guardians
     guardian_id = @stu.collect{|x| x.parent_id }
     s = first.zip(last, email, guardian_id)
     @guardians = []
     s.each do |s|
	if s[3].nil?
	   @parent = Parent.create({:first_name => s[0], :last_name => s[1], :email => s[2]})
           @guardians << Guardian.create({:student_id => @student.id, :parent_id => @parent.id})
        else
	   Parent.update(s[3],{:first_name => s[0], :last_name => s[1], :email => s[2]} )   
        end
     end
     redirect url(:students)
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



