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
      raise params.inspect
      @report = Report.new(params[:report])
      @n = (1..50).to_a
      @messages = []
      if @report.valid?
         @n.each do |f|
            if params["category_#{f}".intern]
               params["category_#{f}".intern][:assignment][:name].each_with_index do |l, i|
                       @assignment = Assignment.create({:name => l, 
                                                        :date => params["category_#{f}".intern][:assignment][:date][i], 
                                                        :max_point => params["category_#{f}".intern][:assignment][:max_point][i]
                                                        })
               end
               if @assignment.valid?
                  @messages << @assignment
               else
                  render :new
               end
            end
         end
         if @messages.empty?
            flash[:error] = "please enter Assignment Details"
            render :new
         else 
           redirect resource(:reports)
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
