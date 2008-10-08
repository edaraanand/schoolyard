class People < Application
	
       
  def index
     @people = Person.find(:all)
     render
  end
  
  def new
     @person = Person.new
     @accesses = Access.find(:all)
     @access_view = Access.find(:first, :conditions => ['name=?', "view_all"])
     puts @access_view.inspect
     render
  end
  
  def create
     @access = params[:access][:access_ids]
     puts @access.inspect
     @access_view = Access.find(:first, :conditions => ['name=?', "view_all"])
     @person = Staff.create(params[:person])
     @access_view_all = AccessPeople.create({:person_id => @person.id, :access_id => @access_view.id})
     if params[:select_all] == "Select all"
	 AccessPeople.create({:person_id => @person.id, :all => true})
     else
	@access.each do |f|
          @access_people = AccessPeople.create({:person_id => @person.id, :access_id => f })
        end
     end
     redirect url(:people)
  end
  
  def edit
      @person = Person.find(params[:id]) 
      @accesses = Access.find(:all)
      @access_people = @person.access_peoples
      render
  end
  
  def update
      @person = Person.find(params[:id])
      @a = Access.find(:all)
      @acc = @a.delete_if{|x| x.name == "view_all"}
      @acc = @a.collect{|x| x.id}
      @access_view = Access.find(:first, :conditions => ['name=?', "view_all"])
      @access = params[:access][:access_ids]
      @access_peoples = @person.access_peoples
      @access_all = @access_peoples.collect{|x| x.all}
      @access_id = @access_peoples.collect{ |x| x.id }
      @access_people_id = @access_peoples.collect{|x| x.access_id}
      if @acc.length == @access.length
	   AccessPeople.destroy(@access_id)
	   AccessPeople.create({:person_id => @person.id, :access_id => @access_view.id})
	   AccessPeople.create({:person_id => @person.id, :all => true})
      elsif (params[:select_all] == "Select all")
	   AccessPeople.destroy(@access_id)
	   AccessPeople.create({:person_id => @person.id, :access_id => @access_view.id})
	   AccessPeople.create({:person_id => @person.id, :all => true})
      else
	   s = @access.zip(@access_id, @access_people_id)
	    AccessPeople.destroy(@access_id)
	     AccessPeople.create({:person_id => @person.id, :access_id => @access_view.id})
	   s.each do |l|
		   if l[1].nil?
		      AccessPeople.create({:person_id => @person.id, :access_id => l[0] })
		   elsif ((l[2].nil?) && l[1].nil?)
			AccessPeople.create({:person_id => @person.id, :access_id => l[0] })
		   else
			AccessPeople.create({:person_id => @person.id, :access_id => l[0]})
		   end		   
	   end
	 
      end
       @person.update_attributes(params[:person])
       redirect url(:people)	  
  end
  
  def disable
      render
  end
  
end
