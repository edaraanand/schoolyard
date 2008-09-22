class Announcements < Application
  layout 'admin'

  before :access_rights, :exclude => [:show_announcements, :show]

  def index
    #  @announcements = Announcement.paginate :page => params[:page], :order => 'expiration', :per_page => 2
    @announcements = Announcement.find(:all, :order => 'expiration')
    render
  end

  def new
    @announcement = Announcement.new
    render
  end

  def create
    if params[:preview]
      render :preview
    else
      @announcement = Announcement.new(params[:announcement])
      if @announcement.save
        redirect url(:announcements)
      else
        render :new
      end
    end
  end

  def edit
    @announcement = Announcement.find(params[:id])
    render
  end

  def update
    @announcement = Announcement.find(params[:id])
    if @announcement.update_attributes(params[:announcement])
      redirect url(:announcements)
    else
      render :edit
    end
  end

  def delete
    Announcement.find(params[:id]).destroy
    redirect url(:announcements)
  end

  def preview
    render :layout => 'preview'
  end

  def show_announcements
    @announcements = Announcement.find(:all)
    render :layout => 'application'
  end

  def show
    puts "Eshwar Deep"
    @announcement = Announcement.find(params[:id])
    render :layout => 'application'
  end

  private

  def access_rights
    unless current_user.announcement_access == true
      redirect url(:homes)
    end
  end

end
