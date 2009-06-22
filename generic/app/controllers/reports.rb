class Reports < Application

   layout 'default'
   before :access_rights
   before :find_school
   before :classrooms
   
   def index
     @reports = @current_school.reports.find(:all)
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
         if params[:report][:classroom_id] != ""
             @classroom = @current_school.classrooms.find_by_class_name(params[:report][:classroom_id])
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
                   @assignments = @category.assignments.create({  :name => l[0], :max_point => l[1], :school_id => @current_school.id })
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
                        @assignments_e = @category_e.assignments.create({  :name => l[0], :max_point => l[1], :school_id => @current_school.id })
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
   
   
   def grades
     @assignment = @current_school.assignments.find(params[:id])
     @category = @assignment.category
     @report = @category.report
     @classroom = @report.classroom
     render
   end
   
   def score
     raise params.inspect
   end
   
   def edit
      @report = @current_school.reports.find(params[:id])
      @categories = @report.categories
      render
   end
   
   def update
      raise params.inspect
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
   end
  
end
