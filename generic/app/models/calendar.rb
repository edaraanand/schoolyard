class Calendar < ActiveRecord::Base
	
      validates_presence_of :title
      validates_presence_of :start_date, :if => Proc.new{|c| c.day_event != true }
      validates_presence_of :end_date, :if => Proc.new{|c| c.day_event != true }	

end
