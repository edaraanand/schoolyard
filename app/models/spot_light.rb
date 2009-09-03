class SpotLight < ActiveRecord::Base

  attr_accessor :image

  belongs_to :school

  validates_presence_of :student_name, :last_name, :content
 
  def name
    (student_name and last_name) ? student_name + ' ' + last_name : ''
  end
  
  def validate
     if self.class_name == ""
        self.errors.add("please", "select the option")
     end
     unless self.image == ""
       @content_types = ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
       unless @content_types.include?(self.image[:content_type])
         self.errors.add("please", "upload a image")
       end 
     end
  end


end
