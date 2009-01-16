class FromPrincipals < Application
  layout 'default'
  before :find_school

  def index
     @announcements = @current_school.announcements.find(:all, :conditions => ['label=?', "from_principal"])
     render
  end
  
  def new
     @announcement = Announcement.new
     render
  end
  
  def create
     @announcement = @current_school.announcements.new(params[:announcement])
     @announcement.label = "from_principal"
     if @announcement.save
        unless params[:announcement][:attachment].empty?
          @attachment = Attachment.create( :attachable_type => "Announcement",
                                        :attachable_id => @announcement.id,
                                        :filename => params[:announcement][:attachment][:filename],
                                        :content_type => params[:announcement][:attachment][:content_type],
                                        :size => params[:announcement][:attachment][:size]
            )
           File.makedirs("public/uploads/#{@attachment.id}")
           FileUtils.mv(params[:announcement][:attachment][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
        end
        redirect resource(:from_principals)
     else
	      render :new
     end
  end

  def edit
     @announcement = Announcement.find(params[:id])
     render
  end
  
  def update
     @announcement = Announcement.find(params[:id])
     if @announcement.update_attributes(params[:announcement])
        Attachment.delete_all(['attachable_id = ?', @announcement.id])
           unless params[:announcement][:attachment].empty?
               @attachment = Attachment.create( :attachable_type => "Announcement",
                                        :attachable_id => @announcement.id,
                                        :filename => params[:announcement][:attachment][:filename],
                                        :content_type => params[:announcement][:attachment][:content_type],
                                        :size => params[:announcement][:attachment][:size]
               )
           end
        @announcement.label = "from_principal"
        @announcement.save
        redirect resource(:from_principals)
     else
	      render :edit
     end
  end
  
  def show
     @announcement = Announcement.find(params[:id])
     render
  end
  
  def delete
     @announcement = Announcement.find(params[:id])
     Attachment.delete_all(['attachable_id = ?', @announcement.id])
     @announcement.destroy
     redirect resource(:from_principals)
  end
  
   def preview
      render :layout => 'preview'
   end
  
end
