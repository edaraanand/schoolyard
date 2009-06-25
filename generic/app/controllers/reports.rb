class Reports < Application

   layout 'default'
   before :access_rights
   before :find_school
   before :classrooms
   
   def index
     @ranks = @current_school.ranks.find(:all)
     if params[:label] == "classes"
        @reports = @current_school.reports.find(:all, :conditions => ['classroom_id = ?', params[:id] ])
        @test = params[:id].to_s
     else
        @reports = @current_school.reports.find(:all)
        @test == "All Subjects"
     end
     render
   end
   
   def new
     @report = Report.new
     @category = Category.new
     @assignment = Assignment.new
     render
   end
   
   def create
      @report = @current_school.reports.new(params[:report].merge(:person_id => session.user.id, :school_id => @current_school.id))
      if @report.valid?
         @classroom = @current_school.classrooms.find_by_class_name(params[:report][:classroom_id])
         #@students = Student.find( :all, :joins => :studies, :conditions => ['studies.classroom_id = ?', @classroom.id] )
         #student_id = @students.collect{|x| x.id}
         if params[:report][:classroom_id] != ""
             @report.classroom_id = @classroom.id
             @report.save
             name = params[:category][:assignment][:name]
             max_p = params[:category][:assignment][:max_point]
             category_names = params[:category][:category_name]
             category_names.each do |f|
                @category = @report.categories.create({:category_name => "#{f}", :school_id => @current_school.id })
             end
             s = name.zip(max_p)
             s.each do |l|
                if ( (l[0] != "") && (l[1] != "")  )
                    @assignment = @category.assignments.create({  :name => l[0], :max_point => l[1], :school_id => @current_school.id })
                   # unless l[2].nil?
                   #    StudentAssignment.create({:student_id => l[2], :assignment_id => @assignment.id })
                   # end
                end
             end
            @category_array = (0..50).to_a
            @category_array.each do |f|
               if params["category_#{f}".intern]
                  names = params["category_#{f}".intern][:assignment][:name]
                  max_points = params["category_#{f}".intern][:assignment][:max_point]
                  category_n = params["category_#{f}".intern][:category_name]
                  category_n.each do |f|
                    @category_e = @report.categories.create({:category_name => "#{f}", :school_id => @current_school.id })
                  end
                  s = names.zip(max_points)
                  s.each do |l|
                     if ( (l[0] != "") && (l[1] != "")  )
                        @assignment_e = @category_e.assignments.create({  :name => l[0], :max_point => l[1], :school_id => @current_school.id })
                       # unless l[2].nil?
                       #    StudentAssignment.create({:student_id => l[2], :assignment_id => @assignment_e.id })
                       # end
                     end
                  end
               end
            end
            redirect resource(:reports)
         else
            flash[:error] = "please select the classroom"
            render :new
         end
      else
        render :new
      end
   end
   
   def assignments
     @report = @current_school.reports.find(params[:id])
     @categories = @report.categories 
     render
   end
   
   
   def add_grades
     @assignment = @current_school.assignments.find(params[:id])
     @category = @assignment.category
     @report = @category.report
     @classroom = @report.classroom
     render
   end
   
   def edit_grades
     @assignment = @current_school.assignments.find(params[:id])
     @category = @assignment.category
     @report = @category.report
     @grades = @assignment.grades
     render
   end
   
   def update_grades
     @assignment = @current_school.assignments.find(params[:id])
     @category = @assignment.category
     @report = @category.report
     @classroom = @report.classroom
     @assignment.date = params[:assignment][:date]
     @assignment.save
     @students = Student.find( :all, :joins => :studies, :conditions => ['studies.classroom_id = ?', @classroom.id] )
     @grades = @assignment.grades.collect{|x| x.id}
     students_id = @students.collect{|x| x.id}
     scores = params[:assignment][:score]
     s = students_id.zip(scores, @grades)
     s.each do |l|
        calculate(l[1], @assignment.max_point)
        Grade.update(l[2], {:student_id => "#{l[0]}", :assignment_id => "#{@assignment.id}", :score => "#{l[1]}", :percentage => Integer("#{l[1]}")*100/@assignment.max_point, :grade => @gr})
     end
     redirect url(:assignments, :id => @report.id) 
   end
   
   def score
     @assignment = @current_school.assignments.find(params[:id])
     @assignment.date = params[:assignment][:date]
     @assignment.save
     @category = @assignment.category
     @report = @category.report
     @classroom = @report.classroom
     @ranks = @current_school.ranks.find(:all)
     students = Student.find( :all, :joins => :studies, :conditions => ['studies.classroom_id = ?', @classroom.id] )
     students_id = students.collect{|x| x.id}
     scores = params[:assignment][:score]
     s = students_id.zip(scores)
     s.each do |l|
        calculate(l[1], @assignment.max_point)
        Grade.create({:student_id => "#{l[0]}", :assignment_id => "#{@assignment.id}", :score => "#{l[1]}", :percentage => Integer("#{l[1]}")*100/@assignment.max_point, :grade => @gr})
     end
     redirect url(:assignments, :id => @report.id)
   end
   
   def grades
     @assignment = @current_school.assignments.find(params[:id])
     @category = @assignment.category
     @report = @category.report
     @grades = @assignment.grades 
     render
   end
   
   def edit
     @assignment = @current_school.assignments.find(params[:id])
     @category = @assignment.category
     @report = @category.report
     @classroom = @report.classroom
     @students = Student.find( :all, :joins => :studies, :conditions => ['studies.classroom_id = ?', @classroom.id] )
     render
   end
   
   
   def update
      raise params.inspect
      render
   end
    
   def view_report
     @report = @current_school.reports.find(params[:id])
     @categories = @report.categories
     render
   end
   
   
   private
   
   def access_rights
      @selected = "grades"
      have_access = false
      @view = Access.find_by_name('view_all')
      @ann = Access.find_by_name('grades')
      @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
      @access_people.each do |f|
        have_access = (f.all == true) || (f.access_id == @ann.id)
        break if have_access
      end
      unless have_access
        redirect resource(:homes)
      end
   end  
   
   def classrooms
      @classrooms = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
     # @classes = @classrooms.collect{|x| x.class_name.titleize }
      #@classrooms = room.insert(0, "All Subjects")
   end
   
   def calculate(id, max)
      @ranks = Rank.find(:all)
      @ranks.each do |f|
         range = Range.new(Integer(f.from), Integer(f.to))
         array = range.to_a
         x = Integer(id)*100/max
         if array.include?(x)
            @gr = "#{f.name}"
         end
      end
   end
  
end
