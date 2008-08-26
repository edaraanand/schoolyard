class Schools < Application
  
  def index
    @school = School.find(:first)
    render
  end
  
  def new
    @school = School.new
    render
  end
  
  def create
    @school = School.new(params[:school])
    @school.save
    redirect url(:school)
  end
  
   def edit
     @school = School.find(:first)
     render
  end
  
  def update
    @school = School.find(:first)
       if @school.update_attributes(params[:school])     
          redirect url(:school)
       else
          render :action => 'edit'
       end
  end
  
end
