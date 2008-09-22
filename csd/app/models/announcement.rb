class Announcement < ActiveRecord::Base

   # include MerbPaginate::Finders::Activerecord

   validates_presence_of :content
  
end
