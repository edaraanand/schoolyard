class Form < ActiveRecord::Base
  
  #has_one :attachment
  validates_presence_of :title
  validates_presence_of :attachment, :message => 'Please Upload a Form'
  
   require 'ftools'
   include FileUtils

  def attachments
    @attachments = Attachment.all(:attachable_type => "Form", :attachable_id => self.id)
  end
  
  def attachment
    @attachment
  end
  
  def attachment=(value)
    @attachment = value
    unless value.empty?
      attachment = Attachment.create( :attachable_type => "Form",
                                      :attachable_id => self.id,      
                                      :filename => @attachment[:filename],
                                      :content_type => @attachment[:content_type],
                                      :size => @attachment[:size]
      )
      File.makedirs("public/uploads/#{attachment.id}")
      mv(@attachment[:tempfile].path, "public/uploads/#{attachment.id}/#{attachment.filename}")
 
      # or partition the path if you are expecting a LOT of attachments
      # path = File.join('public', 'uploads', partitioned_path(attachment.id))
      # File.makedirs(path)
      # mv(@attachment[:tempfile].path, File.join(path, attachment.filename))
    end
  end
 
  protected
 
  def partitioned_path(id)
    ("%06d" % id).scan(/.../)
  end

             
  end
