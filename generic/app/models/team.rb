class Team < ActiveRecord::Base
	
	has_many :class_peoples
	has_many :classrooms, :through => :class_peoples, :source => :classroom
	
	has_many :class_peoples
	has_many :people, :through => :class_peoples, :source => :person
	
	validates_presence_of :team_name
end
