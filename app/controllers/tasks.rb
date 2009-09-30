class Tasks < Application

 layout 'form'
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
    @capture = @current_school.captures.find_by_id(params[:id]) rescue NotFound
    @tasks = @capture.tasks
    @task = @capture.tasks.find_by_name(params[:task])
    @peopl_task = PeopleTask.create({:person_id => session.user.id,
                                     :task_id => @task.id, :hours => params[:hour], 
                                     :comments => params[:comment], :task_date => params[:date]})
    redirect resource(:tasks, :new, :id => @capture.id)
  end
  
  def edit
    @capture = @current_school.captures.find_by_id(params[:id])
    raise NotFound unless @capture
    if Date.today <= @capture.expiration
      @tasks = @capture.tasks
      @selected = @capture.title
      render
    else
      raise NotFound
    end
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
    redirect resource(:tasks, :id => @capture.id)
  end
  
  def delete
    @people_task = PeopleTask.find_by_id(params[:id]) rescue NotFound
    @task = Task.find_by_id(@people_task.task_id)
    @people_task.destroy
    redirect resource(:tasks, :new, :id => @task.capture_id)
 end
  
  private
  
  def selected_tab
     @select = "forms"
  end
  
end
