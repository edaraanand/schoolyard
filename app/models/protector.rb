class Protector < ActiveRecord::Base
  
   has_many :ancestors
   has_many :students, :through => :ancestors, :source => :student
   belongs_to :school
   
   validates_presence_of :first_name, :last_name  #, :email
   validates_uniqueness_of :email, :scope => :school_id, :if => :email 
   validates_format_of :email, :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i, :if => :email
   
   	def name
       "#{first_name}"  "     "    "#{last_name}" 
    end
  
end
