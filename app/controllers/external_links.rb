class ExternalLinks < Application
  layout 'default'
  before :find_school
  before :access_rights

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
       redirect url(:homes)
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
    if params[:link]
      s = title.zip(url, @external_ids)
      links = []
      s.each do |l|
        links << @current_school.external_links.update(l[2], {:title => l[0], :url => l[1], :label => params[:label]})
      end
      params[:link][:title].each_with_index do |e, m|
        @external_link = @current_school.external_links.create({:title => e, :url => params[:link][:url][m], :label => params[:label]})
      end
      if @external_link.valid?
        redirect url(:homes)
      else
        flash[:error] = "please enter Title or Url"
        render :edit
      end
    else
      s = title.zip(url, @external_ids)
      links = []
      s.each do |l|
        links << @current_school.external_links.update(l[2], {:title => l[0], :url => l[1], :label => params[:label]})
      end
      redirect url(:homes)
    end
  end

  def delete
    @current_school.external_links.find(params[:id]).destroy
    redirect url(:homes)
  end

  def preview
    @title = params[:external_link][:title]
    @url = params[:external_link][:url]
    render :layout => 'preview'
  end


  private

  def classrooms
    @classrooms = @current_school.classrooms
  end

  def access_rights
    @selected = "e_links"
    have_access = false
    @view = Access.find_by_name('view_all')
    @ann = Access.find_by_name('external_links')
    @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
    @access_people.each do |f|
      have_access = (f.all == true) || (f.access_id == @ann.id)
      break if have_access
    end
    unless have_access
      redirect resource(:homes)
    end
  end


end
