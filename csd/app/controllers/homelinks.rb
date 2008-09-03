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
       puts "Eshwar"
          @homelinks = Homelink.find(:all)
          
      render
   end

   def update
      title = params[:homelink][:title]
      link = params[:homelink][:link]

             links = []
      @homelinks = Homelink.find(:all)
       @home = @homelinks.collect{|x|  x.id }  
        link = title.zip(link, @home)
                                         
       link.each do |l|
            if l[2].nil?
                 links << Homelink.create!({:title => l[0], :link => l[1]})
            else
                 links << Homelink.update(l[2], {:title => l[0], :link => l[1] } )
            end
        end
           
        redirect url(:homelinks)      
    end

   def delete
     Homelink.find(params[:id]).destroy
     redirect url(:homelinks)
   end
   




end
