module ActiveRecord #:nodoc:
  class Base
    def next_id
      @next ||= self.class.find(:first, :select => ['id'],:conditions => ["id > ? and label=? and school_id = ?", id, "from_principal", self.school_id], :order => 'id')
      @next ? @next.id : nil
    end

    def previous_id
      @previous ||= self.class.find(:first, :select => ['id'],:conditions => ["id < ? and label=? and school_id = ?", id, "from_principal", self.school_id ], :order => "id desc")
      @previous ? @previous.id : nil
    end
    
    def next_record
      @next ||= self.class.find(:first, :select => ['id'],:conditions => ["id > ? and access_name=? and school_id = ?", id, "Home Page", self.school_id], :order => 'id')
      @next ? @next.id : nil
    end

    def previous_record
      @previous ||= self.class.find(:first, :select => ['id'],:conditions => ["id < ? and access_name=? and school_id = ?", id, "Home Page", self.school_id], :order => "id desc")
      @previous ? @previous.id : nil
    end
    
    def next_class_announcement
        @announcement = Announcement.find_by_id(id)
        @next ||= self.class.find(:first, :select => ['id'],:conditions => ["id > ? and access_name=? and school_id = ?", id, @announcement.access_name, self.school_id ], :order => 'id')
        @next ? @next.id : nil
    end

    def previous_class_announcement
       @announcement = Announcement.find_by_id(id)
       @previous ||= self.class.find(:first, :select => ['id'], :conditions => ["id < ? and access_name=? and school_id = ?", id, @announcement.access_name, self.school_id], :order => "id desc")
       @previous ? @previous.id : nil
    end
    
    def next_announcement
       @next ||= self.class.find(:first, :select => ['id'],:conditions => ["id > ? and label=?  and school_id = ?", id, "staff", self.school_id ], :order => 'id')
       @next ? @next.id : nil
    end

    def previous_announcement
       @previous ||= self.class.find(:first, :select => ['id'], :conditions => ["id < ? and label=? and school_id = ?", id, "staff", self.school_id], :order => "id desc")
       @previous ? @previous.id : nil
    end
    
    def next_parent_announcement
       @next ||= self.class.find(:first, :select => ['id'],:conditions => ["id > ? and label=? and person_id=? and school_id = ?", id, "parent", self.person.id, self.school_id ], :order => 'id')
       @next ? @next.id : nil
    end

    def previous_parent_announcement
       @previous ||= self.class.find(:first, :select => ['id'], :conditions => ["id < ? and label=? and person_id=? and school_id = ?", id, "parent", self.person.id, self.school_id], :order => "id desc")
       @previous ? @previous.id : nil
    end
    
    # Finding Homework for a Classroom
    
    def next_class_home_work
       @home_work = HomeWork.find_by_id(id)
       @classroom = @home_work.classroom    
       @next ||= self.class.find(:first, :select => ['id'],:conditions => ["id > ? and classroom_id = ? and school_id = ?", id, @classroom.id, self.school_id ], :order => 'id')
       @next ? @next.id : nil
    end
    
    def previous_class_home_work
       @home_work = HomeWork.find_by_id(id)
       @classroom = @home_work.classroom  
       @previous ||= self.class.find(:first, :select => ['id'], :conditions => ["id < ? and classroom_id = ? and school_id = ?", id, @classroom.id, self.school_id], :order => "id desc")
       @previous ? @previous.id : nil
    end
    
    # Finding SpotLight for a Classroom
     
    def next_class_spot_light
       @spot_light = SpotLight.find_by_id(id)
       @next ||= self.class.find(:first, :select => ['id'],:conditions => ["id > ? and class_name = ? and school_id = ?", id, @spot_light.class_name, self.school_id], :order => 'created_at')
       @next ? @next.id : nil
    end
    
    def previous_class_spot_light
       @spot_light = SpotLight.find_by_id(id)
       @previous ||= self.class.find(:first, :select => ['id'], :conditions => ["id < ? and class_name = ? and school_id = ?", id, @spot_light.class_name, self.school_id], :order => "created_at desc")
       @previous ? @previous.id : nil
    end
    
    
    # used for home works and Spotlights
    def next_common
       @next ||= self.class.find(:first, :select => ['id'],:conditions => ["id > ? and school_id = ?", id, self.school_id], :order => 'id')
       @next ? @next.id : nil
    end
    
    def previous_common
       @previous ||= self.class.find(:first, :select => ['id'], :conditions => ["id < ? and school_id = ?", id, self.school_id], :order => "id desc")
       @previous ? @previous.id : nil
    end
    
    
  end
end
