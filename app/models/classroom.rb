class Classroom < ActiveRecord::Base

  belongs_to :school

  has_many :external_links
  has_many :class_peoples, :dependent => :destroy
  has_many :people, :through => :class_peoples, :source => :person

  has_many :studies
  has_many :students, :through => :studies, :source => :student

  has_many :class_peoples
  has_many :teams, :through => :class_peoples, :source => :team

  has_many :home_works
  
  has_many :reports
  
  has_many :alert_peoples
  
  
 	validates_presence_of :class_name, :if => Proc.new{|c| c.class_type != "Sports" }
  validates_uniqueness_of :class_name, :scope => :school_id
  #validates_presence_of :person_id, :message => "please select Faculty from the list"
  

end
