class Form < ActiveRecord::Base
  
   belongs_to :school
  # has_many  :attachments, :as => :attachable, :dependent => :destroy
 
   validates_presence_of :title
   attr_accessor :attachment
  
     
end
