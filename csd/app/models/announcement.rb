class Announcement < ActiveRecord::Base

   # include MerbPaginate::Finders::Activerecord

   validates_presence_of :title, :content, :expiration
   validates_uniqueness_of :title

end
