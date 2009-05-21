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
  has_many :spot_lights
  has_one :twitter


  validates_presence_of :school_name, :if  => :school_name
  validates_presence_of :address1, :if  => :address1
  validates_presence_of :city, :if  => :city
  validates_presence_of :state, :if  => :state
  validates_presence_of :zip_code, :if  => :zip_code
  validates_format_of :zip_code, :if  => :zip_code, :with => %r{\d{5}(-\d{4})?}, :message => "should be 12345 or 12345-1234"

  #validates_presence_of :phone, :if => :phone
  validates_presence_of :email, :if => :email
  validates_format_of :email, :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i, :if => :email
  validates_length_of :phone, :is => 10, :message => 'must be 10 digits, excluding special characters such as spaces and dashes.', :if => Proc.new{|o| !o.phone.blank?}
  #validates_presence_of :fax
  validates_length_of :fax, :is => 10, :message => 'must be 10 digits, excluding special characters such as spaces and dashes.', :if => Proc.new{|o| !o.fax.blank?}
  validates_presence_of :subdomain, :if => :subdomain
  validates_uniqueness_of :school_name
  validates_uniqueness_of :subdomain, :if => :subdomain
  

end

