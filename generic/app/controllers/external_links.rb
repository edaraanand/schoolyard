class ExternalLinks < Application

  def index
     @external_links = ExternalLink.find(:all)
     render
  end
  
  def new
     @external_link = ExternalLink.new
     render
  end
  
  def create
      params[:external_link][:title].each_with_index do |l, i|
	ExternalLink.create!({:title => l, :url => params[:external_link][:url][i], :label => params[:label]})
      end
      redirect url(:external_links)
  end     
	  
  def edit
     @external_links = ExternalLink.find(:all, :conditions => ['label=?', params[:label] ])
     render
  end
  
  def update
     @external_links = ExternalLink.find(:all, :conditions => ['label=?', params[:label] ])
     @external_ids = @external_links.collect{|x| x.id}
     title = params[:external_link][:title]
     url = params[:external_link][:url]
     s = title.zip(url, @external_ids)
     links = [] 
        s.each do |l|
	    if l[2].nil?
		links << ExternalLink.create!({:title => l[0], :url => l[1], :label => params[:label]})
	    else
		links << ExternalLink.update(l[2], {:title => l[0], :url => l[1], :label => params[:label]})
	    end
        end
	redirect url(:external_links)
  end
  
  def delete
     ExternalLink.find(params[:id]).destroy
     redirect url(:external_links)
  end
  
end
