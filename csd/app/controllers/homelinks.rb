class Homelinks < Application
     
   layout 'admin'
   before :access_rights

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
    puts s.inspect
    links = []
      s.each do |l|
        links << Homelink.create!({:title => l[0], :link => l[1]})
      end
    redirect url(:homelinks)
  end
    
  def edit
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
   
   def preview
      @title = params[:homelink][:title]
      @link = params[:homelink][:link]
      render :layout => 'preview'
   end

   private
   
   def access_rights
      unless current_user.links_access == true
        redirect url(:homes)
      end
   end   

end
