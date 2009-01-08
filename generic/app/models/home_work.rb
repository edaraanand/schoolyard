class HomeWork < ActiveRecord::Base
  
   belongs_to :classroom
   belongs_to :person
   validates_presence_of :title, :content
   
   attr_accessor :attachment
   
end
