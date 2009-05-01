class Reports < Application

   layout 'default'
   before :access_rights
   before :find_school
   
   def index
     @reports = @current_school.reports.find(:all)
     render
   end
   
   def new
     @report = Report.new
     @category = Category.new
     @assignment = Assignment.new
     #5.times { @category.assignments.build }
     render
   end
   
   def create
      @report = @current_school.reports.new(params[:report].merge(:person_id => session.user.id))
      @n = (1..100).to_a
      @n.each do |f|
         if params["category_#{f}".intern]
            names = params["category_#{f}".intern][:assignment][:name]
            dates = params["category_#{f}".intern][:assignment][:date]
            max_points = params["category_#{f}".intern][:assignment][:max_point]
            @report.save
            @category = @report.categories.create({:category_name => params["category_#{f}".intern][:category] })
            s = names.zip(dates, max_points)
            s.each do |l|
               if ( ( (l[0] != "") && (l[1] != "") ) && (l[2] != "") )
                  @assignment = @category.assignments.create({  :name => l[0], :date => l[1], :max_point => l[2] })
               end
            end
         end
      end
      redirect url(:grades, :id => @report.id)
   end
   
   def grades
      @report = @current_school.reports.find(params[:id])
      @categories = @report.categories
      render
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
   
  
end
