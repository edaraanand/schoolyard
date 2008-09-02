class Homelinks < Application

  # ...and remember, everything returned from an action
  # goes to the client...

  def index
    @homelinks = Homelink.find(:all)
    render
  end
  
  def new
    @homelink = Homelink.new
     render
  end

   def create
      title = params[:homelink][:title]
      link = params[:homelink][:link]
     
       s = title.zip(link)
       links = []
       puts s.inspect
          s.each do |l|
	     links << Homelink.create!({:title => l[0], :link => l[1]})
           end
      
        redirect url(:homelinks)
   end
    
   def edit
      @homelinks = Homelink.find(:all)
      render
   end


   







end
