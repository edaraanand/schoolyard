module ActiveRecord #:nodoc:
  class Base
    def next_id
      @next ||= self.class.find(:first, :select => ['id'],:conditions => ["id > ? and label=?", id, "from_principal"], :order => 'id')
      @next ? @next.id : nil
    end

    def previous_id
      @previous ||= self.class.find(:first, :select => ['id'],:conditions => ["id < ? and label=?", id, "from_principal"], :order => "id desc")
      @previous ? @previous.id : nil
    end
    
    def next_record
      @next ||= self.class.find(:first, :select => ['id'],:conditions => ["id > ? and access_name=?", id, "Home Page"], :order => 'id')
      @next ? @next.id : nil
    end

    def previous_record
      @previous ||= self.class.find(:first, :select => ['id'],:conditions => ["id < ? and access_name=?", id, "Home Page"], :order => "id desc")
      @previous ? @previous.id : nil
    end
    
    def next_class_announcement
        @announcement = Announcement.find_by_id(id)
        @next ||= self.class.find(:first, :select => ['id'],:conditions => ["id > ? and access_name=?", id, @announcement.access_name ], :order => 'id')
        @next ? @next.id : nil
    end

    def previous_class_announcement
       @announcement = Announcement.find_by_id(id)
       @previous ||= self.class.find(:first, :select => ['id'], :conditions => ["id < ? and access_name=?", id, @announcement.access_name], :order => "id desc")
       @previous ? @previous.id : nil
    end
    
    def next_announcement
       @next ||= self.class.find(:first, :select => ['id'],:conditions => ["id > ? and label=?", id, "staff" ], :order => 'id')
       @next ? @next.id : nil
    end

    def previous_announcement
       @previous ||= self.class.find(:first, :select => ['id'], :conditions => ["id < ? and label=?", id, "staff"], :order => "id desc")
       @previous ? @previous.id : nil
    end
    
    def next_parent_announcement
       @next ||= self.class.find(:first, :select => ['id'],:conditions => ["id > ? and label=? and person_id=?", id, "parent", self.person.id ], :order => 'id')
       @next ? @next.id : nil
    end

    def previous_parent_announcement
       @previous ||= self.class.find(:first, :select => ['id'], :conditions => ["id < ? and label=? and person_id=?", id, "parent", self.person.id], :order => "id desc")
       @previous ? @previous.id : nil
    end
    
    def next_home_work
       @next ||= self.class.find(:first, :select => ['id'],:conditions => ["id > ?", id], :order => 'id')
       @next ? @next.id : nil
    end
    
    def previous_home_work
       @previous ||= self.class.find(:first, :select => ['id'], :conditions => ["id < ?", id], :order => "id desc")
       @previous ? @previous.id : nil
    end
    
    
  end
end
