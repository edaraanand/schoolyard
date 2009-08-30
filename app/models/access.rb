class Access < ActiveRecord::Base
  has_many :access_peoples
  has_many :people, :through => :access_peoples, :source => :person

  has_many :announcements
end


