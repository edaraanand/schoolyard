class Reports < Application

   layout 'wide'
   before :access_rights, :exclude => [:progress_card]
   before :find_school
   before :classrooms
   
   def index
     @ranks = @current_school.ranks.find(:all)
     if params[:label] == "classes"
        @reports = @current_school.reports.find(:all, :conditions => ['classroom_id = ?', params[:id] ], :order => "created_at DESC" )
        @test = params[:id].to_s
     else
        @reports = @current_school.reports.find(:all, :order => "created_at DESC")
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
         if params[:report][:classroom_id] != ""
            @report.classroom_id = @classroom.id
            @report.save
            cat_assignments
            flash[:confirmation] = "The Subject #{@report.subject_name} has been Added."
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
     if params[:label]
        @classroom = @current_school.classrooms.find_by_class_name(params[:label])
        @reports = @current_school.reports.find(:all, :conditions => ['classroom_id = ?', @classroom.id ])
        @report = @current_school.reports.find_by_classroom_id(@classroom.id)
        if @report.nil? 
           redirect url(:reports, :label => "classes", :id => @classroom.id)
        else
           @categories = @report.categories
           render
        end
     elsif params[:ref]
        @report = @current_school.reports.find_by_subject_name(params[:ref])
        @categories = @report.categories
        @reports = @current_school.reports.find(:all)
        render
     else
        @report = @current_school.reports.find_by_id(params[:id])
        raise NotFound unless @report
        @categories = @report.categories
        @reports = @current_school.reports.find(:all)
        render
     end
   end
   
   
   def add_grades
     @assignment = @current_school.assignments.find_by_id(params[:id])
     raise NotFound unless @assignment
     @category = @assignment.category
     @report = @category.report
     @classroom = @report.classroom
     @students = @current_school.students.find( :all, :joins => :studies, :conditions => ["studies.classroom_id = ? and activate = ?", @report.classroom.id, true] )
     render
   end
   
   def edit_grades
     @assignment = @current_school.assignments.find_by_id(params[:id])
     raise NotFound unless @assignment
     @category = @assignment.category
     @report = @category.report
     @students = @current_school.students.find( :all, :joins => :studies, :conditions => ["studies.classroom_id = ? and activate = ?", @report.classroom.id, true] )
     render
   end
   
   def update_grades
     @assignment = @current_school.assignments.find_by_id(params[:id])
     raise NotFound unless @assignment
     @category = @assignment.category
     @report = @category.report
     @classroom = @report.classroom
     @assignment.date = params[:assignment][:date]
     @assignment.save
     @students = @current_school.students.find( :all, :joins => :studies, :conditions => ["studies.classroom_id = ? and activate = ?", @report.classroom.id, true] )
     @grades = @assignment.grades.collect{|x| x.id}
     students_id = @students.collect{|x| x.id}
     scores = params[:assignment][:score]
     s = students_id.zip(scores, @grades)
     s.each do |l|
        if l[2].nil?
           unless l[1] == ""
             calculate(l[1], @assignment.max_point)
             Grade.create({:student_id => "#{l[0]}", :assignment_id => "#{@assignment.id}", :score => "#{l[1]}", :percentage => Float("#{l[1]}")*100/@assignment.max_point, :grade => @gr})
           end
        else
           unless l[1] == ""
             calculate(l[1], @assignment.max_point)
             Grade.update(l[2], {:student_id => "#{l[0]}", :assignment_id => "#{@assignment.id}", :score => "#{l[1]}", :percentage => Float("#{l[1]}")*100/@assignment.max_point, :grade => @gr})
           else
             Grade.update(l[2], {:student_id => "#{l[0]}", :assignment_id => "#{@assignment.id}", :score => "#{l[1]}", :percentage => nil, :grade => nil})
           end
        end
     end
     redirect url(:assignments, :id => @report.id) 
   end
   
  def score
     raise params.inspect
     @assignment = @current_school.assignments.find_by_id(params[:id])
     raise NotFound unless @assignment
     @assignment.date = params[:assignment][:date]
     @assignment.save!
     @category = @assignment.category
     @report = @category.report
     @classroom = @report.classroom
     @ranks = @current_school.ranks.find(:all)
     students = @current_school.students.find( :all, :joins => :studies, :conditions => ["studies.classroom_id = ? and activate = ?", @classroom.id, true] )
     students_id = students.collect{|x| x.id}
     scores = params[:assignment][:score]
     s = students_id.zip(scores)
     s.each do |l|
        if l[1] != ""
           calculate(l[1], @assignment.max_point)
           Grade.create({:student_id => "#{l[0]}", :assignment_id => "#{@assignment.id}", :score => "#{l[1]}", :percentage => Float("#{l[1]}")*100/@assignment.max_point, :grade => @gr})
        end
     end
     redirect url(:assignments, :id => @report.id)
  end
   
   def grades
     @assignment = @current_school.assignments.find_by_id(params[:id])
     raise NotFound unless @assignment
     @category = @assignment.category
     @report = @category.report
     @students = @current_school.students.find( :all, :joins => :studies, :conditions => ["studies.classroom_id = ? and activate = ?", @report.classroom.id, true] )
     render
   end
   
   def edit
     @report = @current_school.reports.find_by_id(params[:id])
     raise NotFound unless @report
     @categories = @report.categories
     render
   end
   
   
   def update
      @report = @current_school.reports.find_by_id(params[:id])
      raise NotFound unless @report
      @categories = @report.categories
      @category_array = (0..150).to_a
      if @report.valid?
        @classroom = @current_school.classrooms.find_by_class_name(params[:report][:classroom_id])
        @report.update_attributes(params[:report])
        @report.classroom_id = @classroom.id
        @report.save
        @category_array.each do |f|
          if params["cgories_#{f}".intern]
            names = params["cgories_#{f}".intern][:assignment][:name]
            max_points = params["cgories_#{f}".intern][:assignment][:max_point]
            category_n = params["cgories_#{f}".intern][:category_name]
            @category = @current_school.categories.find_by_id("#{f}")
            @c = @report.categories.update(@category.id, {:category_name => "#{category_n}", :school_id => @current_school.id })
            assignments_id =  @category.assignments.collect{|x| x.id}
            s = names.zip(max_points, assignments_id)
            s.each do |l|
              if l[2].nil?
                  if ( (l[0] != "") && (l[1] != "")  )
                      @assignment = Assignment.create({  :name => l[0], :max_point => l[1], :category_id => @category.id, 
                                              :school_id => @current_school.id })
                  end
              else
                  if ( (l[0] != "") && (l[1] != "")  )
                      @assignment_e = @category.assignments.update(l[2], {:name => l[0], :max_point => l[1], 
                                                                  :school_id => @current_school.id })
                  end
              end
            end
          end
        end
        add_categories
        redirect url(:assignments, :id => @report.id)
      else
        render :edit
      end
   end
   
  def add_categories
     if params[:category]
        name = params[:category][:assignment][:name]
        max_p = params[:category][:assignment][:max_point]
        c_name = params[:category][:category_name]
        s = name.zip(max_p)
        q = 1
        s.each do |l|
          if q == 1
            if ( (l[0] != "") && (l[1] != "")  )
              if "#{c_name}" != ""
                  @category = @report.categories.create({:category_name => "#{c_name}", :school_id => @current_school.id }) 
              else 
                  @category = @report.categories.create({:category_name => "category", :school_id => @current_school.id }) 
              end
            end
          end
          if ( (l[0] != "") && (l[1] != "")  )
            @assignment = @category.assignments.create({  :name => l[0], :max_point => l[1], :school_id => @current_school.id })
          end
          q += 1
        end
     end
      @category_array = (0..50).to_a
      @category_array.each do |f|
        if params["category_#{f}".intern]
           names = params["category_#{f}".intern][:assignment][:name]
           max_points = params["category_#{f}".intern][:assignment][:max_point]
           cat_name = params["category_#{f}".intern][:category_name]
            s = names.zip(max_points)
            r = 1
            s.each do |l|
              if r == 1
                if ( (l[0] != "") && (l[1] != "")  )
                   if "#{cat_name}" != ""
                      @category_e = @report.categories.create({:category_name => "#{category_n}", :school_id => @current_school.id })
                   else
                      @category_e = @report.categories.create({:category_name => "category", :school_id => @current_school.id })
                   end
                end
              end 
              if ( (l[0] != "") && (l[1] != "")  )
                  @assignment_e = @category_e.assignments.create({ :name => l[0], :max_point => l[1], :school_id => @current_school.id })
              end
              r += 1
            end
        end
      end
  end
    
   
   def delete
     if params[:ref] == "subject"
        @report = @current_school.reports.find_by_id(params[:id])
        raise NotFound unless @report
        @report.destroy
        redirect resource(:reports)
     elsif params[:ref] == "category"
        @report = @current_school.reports.find_by_id(params[:sub])
        @category = @report.categories.find_by_id(params[:id])
        @category.destroy
        redirect url(:edit_report, :id => @report.id)
     else
       @assignment = @current_school.assignments.find_by_id(params[:id])
       raise NotFound unless @assignment
       @category = @assignment.category
       @report = @category.report
       @assignment.destroy
       redirect url(:edit_report, :id => @report.id)
     end
   end
  
   def cat_assignments
      if params[:category]
         name = params[:category][:assignment][:name]
         max_p = params[:category][:assignment][:max_point]
         category_name = params[:category][:category_name]
         @category = @report.categories.create({:category_name => "#{category_name}", :school_id => @current_school.id })
         s = name.zip(max_p)
         s.each do |l|
           if ( (l[0] != "") && (l[1] != "")  )
              @assignment = @category.assignments.create({  :name => l[0], :max_point => l[1], :school_id => @current_school.id })
           end
         end
      end
      @category_array = (0..50).to_a
      @category_array.each do |f|
         if params["category_#{f}".intern]
            names = params["category_#{f}".intern][:assignment][:name]
            max_points = params["category_#{f}".intern][:assignment][:max_point]
            category_n = params["category_#{f}".intern][:category_name]
            @category_e = @report.categories.create({:category_name => "#{category_n}", :school_id => @current_school.id })
            s = names.zip(max_points)
            s.each do |l|
              if ( (l[0] != "") && (l[1] != "")  )
                 @assignment_e = @category_e.assignments.create({ :name => l[0], :max_point => l[1], :school_id => @current_school.id })
              end
            end
         end
      end
   end
    
   def view_report
     @report = @current_school.reports.find_by_id(params[:id])
     raise NotFound unless @report
     @categories = @report.categories
     @students = @current_school.students.find( :all, :joins => :studies, :conditions => ["studies.classroom_id = ? and activate = ?", @report.classroom.id, true] )
     render
   end
   
   def report_card
      @report = @current_school.reports.find_by_id(params[:id])
      raise NotFound unless @report
      @categories = @report.categories
      @student = @current_school.students.find_by_id(params[:ref])
      render
   end
   
    def progress_card
      @selected = "grades"
      @select = "classrooms"
        @report = @current_school.reports.find_by_id(params[:id])
        @classroom = @current_school.classrooms.find_by_id(params[:c])
        @student = @current_school.students.find_by_id(params[:ref])
        raise NotFound unless @report 
        raise NotFound unless @classroom
        raise NotFound unless @student
        @categories = @report.categories
        @all_reports = @current_school.reports.find(:all, :conditions => ['classroom_id = ?', @classroom.id])
        @test = params[:id]
        render :layout => 'class_change', :id => @classroom.id
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
      @classrooms = @current_school.classes
   end
   
   def calculate(id, max)
      @ranks = Rank.find(:all)
      @ranks.each do |f|
         range = Range.new(Integer(f.from), Integer(f.to))
         array = range.to_a
         x = Float(id)*100/max
         if array.include?(x.to_i)
            @gr = "#{f.name}"
         end
      end
   end
  
end
