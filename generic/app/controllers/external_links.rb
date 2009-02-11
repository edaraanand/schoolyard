class ExternalLinks < Application
  layout 'default'
  before :find_school
 # before :classrooms
  
  def index
     @class_links = @current_school.external_links.find(:all, :conditions => ['label=?', "Classrooms"])
     @home_links = @current_school.external_links.find(:all, :conditions => ['label=?', "Home Page"])
     @sport_links = @current_school.external_links.find(:all, :conditions => ['label=?', "Sports"])
     @event_links = @current_school.external_links.find(:all, :conditions => ['label=?', "Events"])
     render
  end
  
  def new
     @external_link = ExternalLink.new
     render
  end
  
  def create
      params[:external_link][:title].each_with_index do |l, i|
	      @external_link = @current_school.external_links.create({:title => l, :url => params[:external_link][:url][i], :label => params[:label]})
      end
      if @external_link.valid?
         redirect url(:external_links)
      else
         render :new
      end
  end     
	  
  def edit
     @external_links = @current_school.external_links.find(:all, :conditions => ['label=?', params[:label] ])
     render
  end
  
  def update
     @external_links = @current_school.external_links.find(:all, :conditions => ['label=?', params[:label] ])
     @external_ids = @external_links.collect{|x| x.id}
     title = params[:external_link][:title]
     url = params[:external_link][:url]
     s = title.zip(url, @external_ids)
     links = [] 
        s.each do |l|
	         if l[2].nil?
		           links << @current_school.external_links.create!({:title => l[0], :url => l[1], :label => params[:label]})
	         else
		           links << @current_school.external_links.update(l[2], {:title => l[0], :url => l[1], :label => params[:label]})
	         end
        end
	   redirect url(:external_links)
  end
  
  def delete
     ExternalLink.find(params[:id]).destroy
     redirect url(:external_links)
  end
  
  def preview
     @title = params[:external_link][:title]
     @url = params[:external_link][:url]
     render :layout => 'preview'
  end
  
  
  private
  
  def classrooms
    @classrooms = @current_school.classrooms.find(:all)
  end
	  
end
