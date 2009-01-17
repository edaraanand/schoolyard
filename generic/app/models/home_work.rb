class HomeWork < ActiveRecord::Base
  
   belongs_to :classroom
   belongs_to :person
   belongs_to :school
   validates_presence_of :title, :content
   
   attr_accessor :attachment
   
end
