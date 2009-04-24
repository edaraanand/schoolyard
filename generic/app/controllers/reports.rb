class Reports < Application

   layout 'default'
   before :access_rights
   
   def index
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
      @report = Report.new(params[:report])
      if @report.valid?
        params[:category].each do |f|
            
        end
         params[:assignment_1][:name].each_with_index do |l, i|
               @assignment = Assignment.create({ :name => l, 
                                                 :date => params[:assignment_1][:date][i], 
                                                 :max_point => params[:assignment_1][:max_point][i]
                                                })
         end
         if @assignment.valid? && @assignment.save
            @report.save
            params[:category].each do |f|
               @report.categories.create({ :category_name => f })
            end
            raise params.inspect  
         else
            flash[:error] = "You should provide atleast one assignment for each category"
            render :new
         end
      else
         render :new
      end
   end
   
   def edit
     render
   end
   
   def update
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
