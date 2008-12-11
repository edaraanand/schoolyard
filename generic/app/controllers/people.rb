class People < Application
	
  layout 'default'
 
       
  def index
     @people = Person.find(:all)
     render
  end
  
  def new
     @person = Person.new
     @accesses = Access.find(:all).delete_if{|x| x.name == "view_all"}
     @access_view = Access.find(:first, :conditions => ['name=?', "view_all"])
     puts @access_view.inspect
     render
  end
  
  def create
     @accesses = Access.find(:all).delete_if{|x| x.name == "view_all"}
     @person = Staff.new(params[:person])
     if @person.save
        unless params[:access].nil?
	         @access = params[:access][:access_ids]
        end
        @access_view = Access.find(:first, :conditions => ['name=?', "view_all"])
        @access_view_all = AccessPeople.create({:person_id => @person.id, :access_id => @access_view.id})
             if params[:select_all] == "Select all"
	               AccessPeople.create({:person_id => @person.id, :all => true})
             else
                unless params[:access].nil?
	                @access.each do |f|
                     @access_people = AccessPeople.create({:person_id => @person.id, :access_id => f })
                  end
                end
             end
         redirect url(:people)
     else
	      render :new
     end
  end
  
  def edit
      @person = Person.find(params[:id]) 
      @accesses = Access.find(:all).delete_if{|x| x.name == "view_all"}
      @access_people = @person.access_peoples
      puts @access_people.inspect
      render
  end
  
  def update
      @person = Person.find(params[:id])
      @accesses = Access.find(:all).delete_if{|x| x.name == "view_all"}
      @access_people = @person.access_peoples
    if @person.update_attributes(params[:person])   
         @a = Access.find(:all)
         @acc = @a.delete_if{|x| x.name == "view_all"}
         @acc = @a.collect{|x| x.id}
         @access_view = Access.find(:first, :conditions => ['name=?', "view_all"])
         unless params[:access].nil?
            @access = params[:access][:access_ids]
         end
         @access_peoples = @person.access_peoples
         @access_all = @access_peoples.collect{|x| x.all}
         @access_id = @access_peoples.collect{ |x| x.id }
         @access_people_id = @access_peoples.collect{|x| x.access_id}
         if (params[:select_all] == "Select all")
	          AccessPeople.destroy(@access_id)
	          AccessPeople.create({:person_id => @person.id, :access_id => @access_view.id})
	          AccessPeople.create({:person_id => @person.id, :all => true})
         else
            unless params[:access].nil?
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
         end
	       redirect url(:people)
    else
	      render :edit  
    end  
      
  end

  
  def disable
     redirect url(:people)
  end
  
  
    
  
end
