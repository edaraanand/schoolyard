class ExternalLinks < Application
  layout 'default'
  before :find_school
  before :access_rights
  before :classrooms

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
    if params[:label] == "Classrooms"
        @classroom = @current_school.classrooms.find_by_class_name(params[:external_link][:classroom_id])
        @external_link = @current_school.external_links.create({:title => params[:external_link][:title], :label => params[:label],
                                          :url => params[:external_link][:url], :classroom_id => @classroom.id})
       links
       redirect url(:class_details, :id => @classroom.id)
    else
        @external_link = @current_school.external_links.create({:title => params[:external_link][:title], :label => params[:label],
                                     :url => params[:external_link][:url] })
        links
        redirect resource(:homes)
    end
    
  end

  def edit
    if params[:label] == "Classrooms"
       if params[:id]
          @classroom = @current_school.classrooms.find_by_id(params[:id])
          raise NotFound unless @classroom
          @external_links = @current_school.external_links.find(:all, :conditions => ["label = ? and classroom_id = ?", "Classrooms", @classroom.id])
          @test = params[:id]
       end
    else
       @external_links = @current_school.external_links.find(:all, :conditions => ['label=?', params[:label] ])
    end
    render
  end

  def update
    @links = []
    if params[:label] == "Classrooms"
       if params[:id]
          @classroom = @current_school.classrooms.find_by_id(params[:id])
          raise NotFound unless @classroom
          class_links = @current_school.external_links.find(:all, :conditions => ["label = ? and classroom_id = ?", "Classrooms", @classroom.id])
          class_link_ids = class_links.collect{|x| x.id}
          if params[:external_link]
             old_title = params[:external_link][:title]
             old_url = params[:external_link][:url]
             old_s = old_title.zip(old_url, class_link_ids)
             old_s.each do |f|
                a = f.flatten
                @links << @current_school.external_links.update(a[4], {:title => a[1], :url => a[3], 
                                          :classroom_id => params[:id], :label => params[:label] })
             end
          end
          if params[:links]
            links
          end
       end
       redirect url(:class_details, :id => @classroom.id)
    else
       @external_links = @current_school.external_links.find(:all, :conditions => ['label=?', params[:label] ])
       @external_ids = @external_links.collect{|x| x.id}
       if params[:external_link]
          old_title = params[:external_link][:title]
          old_url = params[:external_link][:url]
          old_s = old_title.zip(old_url, @external_ids)
          old_s.each do |f|
            a = f.flatten
            @links << @current_school.external_links.update(a[4], {:title => a[1], :url => a[3], :label => params[:label] })
          end
       end
       links
       @external_links = @current_school.external_links.find(:all, :conditions => ['label=?', params[:label] ])
       redirect resource(:homes)
    end
 
  end

  def delete
    @external_link = @current_school.external_links.find_by_id(params[:id])
    raise NotFound unless @external_link
    label = @external_link.label
    if @external_link.label == "Classrooms"
       @external_link.destroy
       redirect url(:external_links_edit, :label => "Classrooms")
    else
      @external_link.destroy
      redirect url(:external_links_edit, :label => label)
    end
  end

  def preview
    @title = params[:external_link][:title]
    @url = params[:external_link][:url]
    render :layout => 'preview'
  end

  # Adding External Links for new and edit modes
  def links
    if params[:links]
      titles = params[:links][:title]
      url = params[:links][:url]
      s = titles.zip(url)
      @external_links = []
      if params[:label] == "Classrooms"
          s.each do |f|
            a = f.flatten
            if ( a[1] != "")  && (a[3] != "")
               @external_links << @current_school.external_links.create({:classroom_id => @classroom.id, :label => params[:label],
                                  :title => a[1], :url => a[3] })
            end
          end
      else
         s.each do |f|
            a = f.flatten
            if ( a[1] != "")  && (a[3] != "")
               @external_links << @current_school.external_links.create({:title => a[1], :label => params[:label], :url => a[3] })
            end
         end
      end
    end
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
