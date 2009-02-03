class School < ActiveRecord::Base
	
   has_many :people
   has_many :calendars
   has_many :staff
   has_many :welcome_messages
   has_many :forms
   has_many :classrooms
   has_many :teams
   has_many :external_links
   has_many :protectors
   has_many :announcements
   has_many :home_works
   has_many :students
   has_many :parents
   has_many :registrations
   
   validates_presence_of :school_name 
   validates_presence_of :phone, :if => :phone
   validates_presence_of :email, :if => :email
	 validates_format_of :email, :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i, :if => :email
   validates_length_of :phone, :is => 10, :message => 'must be 10 digits, excluding special characters such as spaces and dashes.', :if => Proc.new{|o| !o.phone.blank?}
   validates_presence_of :subdomain, :if => :subdomain      
   validates_uniqueness_of :school_name
   validates_uniqueness_of :subdomain, :if => :subdomain 
   
end