class Attachment < ActiveRecord::Base


  def url
    "/public/uploads/#{self.id}/#{self.filename}"
  end

  belongs_to :school
  
  # Creating Attachment Files for all the modules
  
  def self.file(params, type, id)
    i = 0
    @current_school = School.find_by_id(params[:school_id])
    @attachment = Attachment.create( :attachable_type => type,
                                     :attachable_id => id,
                                     :filename => params[:attachment]['file_'+i.to_s][:filename],
                                     :content_type => params[:attachment]['file_'+i.to_s][:content_type],
                                     :size => params[:attachment]['file_'+i.to_s][:size],
                                     :school_id => @current_school.id
                                    )
     File.makedirs("public/uploads/#{@current_school.id}/files")
     FileUtils.mv( params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@current_school.id}/files/#{@attachment.id}")
  end
  
   # Creating Pictures for users and spot lights
   
  def self.picture(params, type, id)
      if type == "spot_light"
         f = params[:spot_light][:image][:filename]
         size = params[:spot_light][:image][:size]
         content_type = params[:spot_light][:image][:content_type]
         temp = params[:spot_light][:image][:tempfile]
      else
         f = params[:person][:image][:filename]
         size = params[:person][:image][:size]
         content_type = params[:person][:image][:content_type]
         temp = params[:person][:image][:tempfile]
      end
      file = File.basename(f.gsub(/\\/, '/'))
      @current_school = School.find_by_id(params[:school_id])
      @attachment = Attachment.create( :attachable_id => id,
                                       :attachable_type => type,
                                       :filename => file,
                                       :size => size,
                                       :content_type => content_type,
                                       :school_id => @current_school.id
                                     )
      File.makedirs("public/uploads/#{@current_school.id}/pictures")
      FileUtils.mv(temp.path, "public/uploads/#{@current_school.id}/pictures/#{@attachment.id}")
  end
  
  def self.announcements(id, school_id)
    @current_school = School.find_by_id(school_id)
    self.find(:all, :conditions => ["attachable_id = ? and attachable_type =? and school_id = ?", id, "Announcement", @current_school.id])
  end
  
  def self.calendars(id, school_id)
    @current_school = School.find_by_id(school_id)
    self.find(:all, :conditions => ["attachable_id = ? and attachable_type =? and school_id = ?", id, "Calendar", @current_school.id ])
  end

end
