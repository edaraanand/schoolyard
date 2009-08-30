class Team < ActiveRecord::Base

  belongs_to :school
  has_many :class_peoples
  has_many :classrooms, :through => :class_peoples, :source => :classroom

  has_many :class_peoples, :dependent => :destroy
  has_many :people, :through => :class_peoples, :source => :person

  validates_presence_of :team_name
  validates_presence_of :classroom_id, :message => "Please Select the Classroom"
  validates_presence_of :year, :message => "Please Select the Year"

end
