class AccessPeople < ActiveRecord::Base
  belongs_to :access
  belongs_to :person
end
