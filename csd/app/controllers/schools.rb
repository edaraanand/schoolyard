class Schools < Application
   
   layout 'admin'   
   
   before :access_rights
    
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

  private

   def access_rights
      unless current_user.settings_access == true
         redirect url(:homes)
      end
   end
  
end







