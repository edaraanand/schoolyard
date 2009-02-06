class Admin < Application

  layout 'admin'
  
  def index
     @schools = School.find(:all, :conditions => ['subdomain != ?', "admin"])
     render
  end
  
  def new
    @school = School.new
    @person = Person.new
    render
  end
  
  def create
    @school = School.new(params[:school])
    @person = Person.new(params[:person])
    if @school.valid? && @person.valid?
       @subdomain = params[:school][:subdomain]
       @school.domain = "http://" + "#{@subdomain}" + ".schoolyardapp.net"
       @school.folder = "schoolyardappcom"
       @school.save
       @person.school_id = @school.id
       @person.type = "Staff"
       @person.admin = true
       @person.save
       @view = Access.find_by_name('view_all')
        AccessPeople.create({:person_id => @person.id, :access_id => @view.id })
        AccessPeople.create({:person_id => @person.id, :all => true })
       @person.send_pass
       redirect resource(:admin)
    else
       @subdomain = params[:school][:subdomain]
       render :new
    end
  end
  
  def edit
     @school = School.find(params[:id])
     @person = @school.people.find(:first, :conditions => ['admin =?', true])
     render
  end
  
  def update
     @school = School.find(params[:id])
     @person = @school.people.find(:first, :conditions => ['admin =?', true])
     @email = params[:person][:email]
     if @school.update_attributes(params[:school])
        if @person.update_attributes(params[:person])
           redirect resource(:admin)
        else
           render :edit
        end
     else
        render :edit
     end
    
  end
  
  
   
end
