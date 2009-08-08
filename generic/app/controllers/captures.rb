class Captures < Application

  layout 'wide'
  before :find_school
  before :access_rights
  
  def index
     @captures = @current_school.captures.find(:all)
     render
  end
  
  def new
    @capture = Capture.new
    render
  end
  
  def create
    @capture = @current_school.captures.new(params[:capture])
    if @capture.valid?
       @capture.save     
       @tasks = params[:capture][:content].gsub("\r\n", ",").gsub(/[.>-]/, "").split(',') #123456789
       @tasks.each do |f|
          @capture.tasks.create({:name => "#{f}", :school_id => @current_school.id })
       end
       redirect resource(:captures)
    else
       render :new
    end
  end
  
  def edit
    @capture = @current_school.captures.find_by_id(params[:id])
    raise NotFound unless @capture
    @tasks = @capture.tasks.collect{|x| x.name + ","}.to_s.chop
    @capture.content = @tasks.gsub(",", "\r\n") 
    render
  end
  
  def update
     @capture = @current_school.captures.find_by_id(params[:id])
     raise NotFound unless @capture
     if @capture.update_attributes(params[:capture])
        @content =  params[:capture][:content].gsub("\r\n", ",").gsub(/[.>-]/, "").split(',')
        @task_names = @capture.tasks.collect{|x| x.name }
        @task_ids = @capture.tasks.collect{|x| x.id }
        test = []
        if @content.length < @task_names.length
             s = @task_ids.zip(@task_names, @content)
             s.each do |f|
               if f[2].nil?
                  @task = @capture.tasks.find_by_id(f[0])
                  @task.destroy
               else
                  test << @capture.tasks.update(f[0],{:name => f[2], :school_id => @current_school.id })
               end
             end
        else
             s = @content.zip(@task_names, @task_ids)
             s.each do |f|
                if f[2].nil?
                   test << @capture.tasks.create({:name => f[0], :school_id => @current_school.id})
                else
                   test << @capture.tasks.update(f[2],{:name => f[0], :school_id => @current_school.id })
                end
             end
        end
        redirect resource(:captures)
     else 
        render :edit
     end
  end
  
  def delete
    raise params.inspect
  end
  
  def capture_tasks
    @capture = @current_school.captures.find_by_id(params[:id])
    raise NotFound unless @capture
    @tasks = @capture.tasks
    render
  end
  
  def task_parents
    @task = @current_school.tasks.find_by_id(params[:id])
    raise NotFound unless @task
    @capture = @task.capture
    @test = params[:id]
    render
  end
  
  
  private
  
  def access_rights
     @selected = "capture"
     have_access = false
     @view = Access.find_by_name('view_all')
     @ann = Access.find_by_name('time_capture')
     @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
     @access_people.each do |f|
       have_access = (f.all == true) || (f.access_id == @ann.id)
       break if have_access
     end
     unless have_access
       redirect resource(:homes)
     end
  end
  

end