class Tasks < Application

 layout 'directory'
 before :find_school
 before :selected_tab
  
  def index
    @capture = @current_school.captures.find_by_id(params[:id])
    raise NotFound unless @capture
    @tasks = @capture.tasks
    @selected = @capture.title
    render
  end
  
  def new
    @capture = @current_school.captures.find_by_id(params[:id])
    @tasks = @capture.tasks
    @selected = @capture.title
    render
  end
  
  def create
    render
  end
  
  def edit
    @capture = @current_school.captures.find_by_id(params[:id])
    raise NotFound unless @capture
    @tasks = @capture.tasks
    @selected = @capture.title
    render
  end
  
  def update
    @capture = @current_school.captures.find_by_id(params[:id])
    raise NotFound unless @capture
    @tasks = @capture.tasks
    @task_ids = @capture.tasks.collect{|x| x.id }
    test = []
    s = @task_ids.zip(params[:hours], params[:comments])
    s.each do |f|
       @t = @current_school.tasks.find_by_id(f[0])
       @p_task = @t.people_tasks.find(:first, :conditions => ["person_id = ? and task_id = ?", session.user.id, @t.id ] )
       if @p_task.nil?
          test << PeopleTask.create({:person_id => session.user.id, :task_id => f[0], :hours => f[1], :comments => f[2] })
       else
          test << PeopleTask.update(@p_task.id, {:person_id => session.user.id, :task_id => f[0], :hours => f[1], :comments => f[2] })
       end
    end
    redirect resource(:tasks, :id => @capture.id, :label => "forms")
  end
  
  private
  
  def selected_tab
     @select = "forms"
  end
  
end
