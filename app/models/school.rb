class School < ActiveRecord::Base

  has_many :people
  
  has_many :calendars, :order => 'start_date, start_time, class_name'
  has_many :staff
  has_many :welcome_messages
  has_many :forms

  has_many :classrooms, :order => :position
  has_many :active_classrooms, :order => :position, :conditions => ['activate = ?', true], :class_name => "Classroom", :foreign_key => :school_id
  has_many :core_classrooms, :order => :position, :conditions => ['class_name != ? and activate = ?', "Sports", true], :class_name => "Classroom", :foreign_key => :school_id
  has_many :classes, :order => :position, :conditions => ["activate = ? and class_type = ?",  true, "Classes" ], :class_name => "Classroom", :foreign_key => :school_id
  has_many :extra_curricular, :order => :position, :conditions => ["activate = ? and class_type = ?",  true, "Subject" ], :class_name => "Classroom", :foreign_key => :school_id
  
  has_many :announcements, :order => "created_at DESC"
  has_many :teams
  has_many :external_links
  has_many :protectors
  
  has_many :home_works
  has_many :students, :order => "last_name"
  has_many :parents
  has_many :registrations
  has_many :spot_lights
  has_one :twitter
  has_many :attachments
  has_many :reports
  has_many :ranks
  has_many :categories
  has_many :assignments
  
  has_many :captures
  has_many :tasks
  
  has_many :logs, :class_name => "LoggerMachine"
  has_one :principal

  
  
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
  

  def domain
    "https://#{subdomain}.#{Schoolapp.config(:app_domain)}"
  end
  
  # Calendars
  
  def current_week_calendars(class_name, week)
    self.calendars.find(:all, :conditions => {:start_date => from(week)..to(week), :class_name => ["Schoolwide", "#{class_name}"]})
  end
  
  def all_week_calendars(week)
    self.calendars.find(:all, :conditions => {:start_date => from(week)..to(week)})
  end
  
  def from(week)
    $from = weeks(week).beginning_of_week
  end
    
  def to(week)
    $to = weeks(week).end_of_week
  end
    
  def weeks(week)
    weeks = Date.today.beginning_of_week + ( 7 * (week.to_i) )
  end
  
  
  # Student Finders
  
  def class_students(params, class_id)
    self.students.paginate(:all, :joins => :studies,
                           :conditions => ["studies.classroom_id = ? and activate = ?", class_id, true], 
                           :per_page => 25,  :page => params[:page])
  end
  
  def activated_students(params)
    self.students.paginate(:all, :conditions => ["activate = ?", true], 
                           :per_page => 25,  :page => params[:page])
  end
  
  def filters(params)
    self.students.paginate(:all, :conditions => ["last_name LIKE ? and activate = ?","#{params[:type]}%", true], 
                           :per_page => 25,  :page => params[:page] )
  end
    
  
end

