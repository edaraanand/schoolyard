class HomeWorks < Application
  
  layout 'default'
  before :find_school
  before :classrooms, :exclude => [:delete, :preview]
  before :rooms, :only => [:index]
  
  def index
     if params[:classroom_id].nil?
        @h_works = HomeWork.find(:all)
     elsif params[:classroom_id] == "All Home Works"
        @works = HomeWork.find(:all)
     else
        @classroom = Classroom.find_by_class_name(params[:classroom_id])
        @home_works = @classroom.home_works.find(:all)
     end
       @error = "No Homeworks Yet"
     render
  end
  
  def new
    @home_work = HomeWork.new
    render
  end
  
  def create
    @classroom = @current_school.classrooms.find_by_class_name(params[:home_work][:classroom_id])
    @person = session.user
    @home_work = @person.home_works.build(params[:home_work])
    @home_work.classroom_id = @classroom.id
    if @home_work.save
       unless params[:home_work][:attachment].empty?
           @attachment = Attachment.create( :attachable_type => "Homework",
                                        :attachable_id => @home_work.id,
                                        :filename => params[:home_work][:attachment][:filename],
                                        :content_type => params[:home_work][:attachment][:content_type],
                                        :size => params[:home_work][:attachment][:size]
            )
           File.makedirs("public/uploads/#{@attachment.id}")
           FileUtils.mv(params[:home_work][:attachment][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
        end
       redirect resource(:home_works)
    else
       render :new
    end
  end
  
  def edit
    @home_work = HomeWork.find(params[:id])
    render
  end
  
  def update
    @classroom = Classroom.find_by_class_name(params[:home_work][:classroom_id])
    @home_work = HomeWork.find(params[:id])
    if @home_work.update_attributes(params[:home_work])
       Attachment.delete_all(['attachable_id = ?', @home_work.id])
        unless params[:home_work][:attachment].empty?
            @attachment = Attachment.create( :attachable_type => "Homework",
                                        :attachable_id => @home_work.id,
                                        :filename => params[:home_work][:attachment][:filename],
                                        :content_type => params[:home_work][:attachment][:content_type],
                                        :size => params[:home_work][:attachment][:size]
              )
         end
       @home_work.classroom_id = @classroom.id
       @home_work.person_id = session.user.id
       @home_work.save
       redirect resource(:home_works)
    else
	     render :edit
    end
  end
  
  def delete
     @home_work = HomeWork.find(params[:id])
     Attachment.delete_all(['attachable_id = ?', @home_work.id])
     @home_work.destroy
     redirect resource(:home_works)
  end
  
  def preview
    render :layout => 'preview'
  end
 
  
  private
  
  def classrooms
    @classrooms = Classroom.find(:all)
  end
  
  
  def rooms
    classes = Classroom.find(:all)
    room = classes.collect{|x| x.class_name }
    @classes = room.insert(0, "All Home Works")
  end
  
  
end
