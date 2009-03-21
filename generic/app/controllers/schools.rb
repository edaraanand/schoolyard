class Schools < Application
  
  layout 'default'
  before :ensure_authenticated
  before :find_school
   
  def index
     @school = @current_school
     render
  end
  
  def new
    @school = School.new
    render
  end
  
  def create
    @school = School.new(params[:school])
    if @school.save
       redirect resource(:schools)
    else
      	render :new
    end
  end
  
  def edit
    @school = School.find(params[:id])
    render
  end
  
  def update
     @school = School.find(params[:id])
     if @school.update_attributes(params[:school]) 
         @school.address = params[:school][:address]
         @school.save
         redirect resource(:schools)                                     
      else
	       render :edit
      end
  end
  
 
end
