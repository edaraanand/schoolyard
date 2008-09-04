class Announcement < ActiveRecord::Base

   validates_presence_of :title, :content, :expiration
   validates_uniqueness_of :title

end
