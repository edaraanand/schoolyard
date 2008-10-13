class School < ActiveRecord::Base
	
      validates_presence_of :school_name, :phone, :email
	
end