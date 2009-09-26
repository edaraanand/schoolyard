class ExternalLinks < Application
  layout 'default'
  before :find_school
  before :access_rights
  before :classrooms

  def index
    @home_links = @current_school.external_links.find(:all, :conditions => ['label = ?', "Home Page"])
    render
  end

  def new
    @external_link = ExternalLink.new
    render
  end

  def create
    if (params[:label] == "Classrooms" || params[:label] == "Subjects")
        @classroom = @current_school.classrooms.find_by_id(params[:id])
        raise NotFound unless @classroom
        if params[:label] == "Subjects"
          label = "Subjects"
        else
          label = "Classrooms"
        end
        @external_link = @current_school.external_links.create({:title => params[:external_link][:title], :label => label,
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
    if (params[:label] == "Classrooms" || params[:label] == "Subjects") 
       if params[:id]
          @classroom = @current_school.classrooms.find_by_id(params[:id])
          raise NotFound unless @classroom
          if params[:label] == "Subjects"
             label = "Subjects"
          else
             label = "Classrooms"
          end
          @external_links = @current_school.external_links.find(:all, :conditions => ["label = ? and classroom_id = ?", label, @classroom.id])
          @test = params[:id]
       end
    else
       @external_links = @current_school.external_links.find(:all, :conditions => ['label=?', params[:label] ])
    end
    render
  end

  def update
    @links = []
    if (params[:label] == "Classrooms" || params[:label] == "Subjects") 
       if params[:id]
          @classroom = @current_school.classrooms.find_by_id(params[:id])
          raise NotFound unless @classroom
          if params[:label] == "Subjects"
             label = "Subjects"
          else
             label = "Classrooms"
          end
          class_links = @current_school.external_links.find(:all, :conditions => ["label = ? and classroom_id = ?", label, @classroom.id])
          class_link_ids = class_links.collect{|x| x.id}
          if params[:external_link]
             old_title = params[:external_link][:title]
             old_url = params[:external_link][:url]
             old_s = old_title.zip(old_url, class_link_ids)
             old_s.each do |f|
                a = f.flatten
                @links << @current_school.external_links.update(a[4], {:title => a[1], :url => a[3], 
                                          :classroom_id => params[:id], :label => label })
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
    if (label == "Classrooms" || label == "Subjects") 
       if label == "Subjects"
          label = "Subjects"
       else
          label = "Classrooms"
       end
       id = @external_link.classroom_id
       @external_link.destroy
       @external_links = @current_school.external_links.find(:all, :conditions => ['label = ?', label])
       if @external_links.empty?
          redirect resource(:external_links)
       else
          redirect url(:external_links_edit, :label => label, :id => id )
       end
    else
       @external_link.destroy
       @external_links = @current_school.external_links.find(:all, :conditions => ['label = ?', label])
       if @external_links.empty?
          redirect resource(:external_links)
       else
          redirect url(:external_links_edit, :label => label)
       end
    end
  end

  def preview
      n = params[:submit].split(',').flatten
      i = n[0].split('')
      @edit = i.pop ## edit mode
      if @edit == "0"
         @class_id = i.pop
      else
         @class_id = @edit
      end
       @classroom = @current_school.classrooms.find_by_id("#{@class_id}")
    if params[:label] == "Home Page"
       @select = "home"
       render :layout => 'home'
    elsif params[:label] == "Classrooms" 
       render :layout => 'class_change', :id => @classroom.id
    elsif params[:label] == "Subjects" 
       render :layout => 'class_change', :id => @classroom.id
    end
  end

  # Adding External Links for new and edit modes
  def links
    if params[:links]
      titles = params[:links][:title]
      url = params[:links][:url]
      s = titles.zip(url)
      @external_links = []
     if (params[:label] == "Classrooms" || params[:label] == "Subjects") 
         if params[:label] == "Subjects"
            label = "Subjects"
         else
            label = "Classrooms"
         end
          s.each do |f|
            a = f.flatten
            if ( a[1] != "")  && (a[3] != "")
               @external_links << @current_school.external_links.create({:classroom_id => @classroom.id, :label => label,
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
    @classrooms =  @current_school.classes
    @extracurricular = @current_school.extra_curricular
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
