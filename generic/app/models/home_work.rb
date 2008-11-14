class HomeWork < ActiveRecord::Base
   belongs_to :classroom
   
   validates_presence_of :title, :content
   
end
