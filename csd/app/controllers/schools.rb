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
      if @school.save
         redirect url(:schools)
      else
         render :new
      end
  end
  
   def edit
      @school = School.find(:first)
      render
   end
  
  def update
    @school = School.find(:first)
       if @school.update_attributes(params[:school])     
          redirect url(:schools)
       else
          render :edit
       end
  end
  
end
