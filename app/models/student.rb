class Student < Person
	    
	   attr_accessor :file_c
	   
     belongs_to :school
     has_many :guardians
     has_many :parents, :through => :guardians, :source => :parent
     
     has_many :studies
     has_many :classrooms, :through => :studies, :source => :classroom
     
     has_many :ancestors
     has_many :protectors, :through => :ancestors, :source => :protector
     
     has_many :grades
     has_many :assignments, :through => :grades, :source => :assignment
     
     has_one :rank
          
     validates_presence_of :birth_date
    # validates_presence_of :address, :if => :address
    # validates_presence_of :address1, :if  => :address1
    # validates_presence_of :city, :if  => :city
    # validates_presence_of :state, :if  => :state
    # validates_presence_of :zip_code, :if  => :zip_code
    # validates_format_of :zip_code, :if  => :zip_code, :with => %r{\d{5}(-\d{4})?}, :message => "should be 12345 or 12345-1234"
    
    #  named_scope :all, lambda {|c| {:conditions => ["school_id = ?", c] } }
        
    def self.activated_students(params)
      self.paginate(:all, :conditions => ["activate = ? and school_id = ?", true, params[:school_id]], :per_page => 25,  :page => params[:page])
    end
    
    def self.class_students(params, class_id)
      self.paginate(:all, :joins => :studies,
                    :conditions => ["studies.classroom_id = ? and activate = ? and school_id = ?", class_id, true, params[:school_id]], 
                    :per_page => 25,  :page => params[:page] )
    end
    
    def self.filters(params)  
       self.paginate(:all, 
                     :conditions => ["last_name LIKE ? and activate = ? and school_id = ?","#{params[:type]}%", true, params[:school_id] ], 
                     :per_page => 25,  :page => params[:page] )
    end
 
end
