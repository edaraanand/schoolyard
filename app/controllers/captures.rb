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
        if params[:capture][:school_staff]
           @capture.school_staff = true
           @capture.save
        else
           @capture.school_staff = false
           @capture.save
        end
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
  
  def xls
    @capture = @current_school.captures.find_by_id(params[:id])
    raise NotFound unless @capture
    xls = generate_xls(@capture)
    send_file(xls, :type => 'application/xls', 
                   :filename => "#{@capture.title} #{Time.now.strftime("%b %d")}" + ".xls",
                   :disposition => 'inline')
  end
  
  def capture_tasks
    @capture = @current_school.captures.find_by_id(params[:id]) rescue NotFound
    @tasks = @capture.tasks
    render
  end
  
  def task_parents
    @task = @current_school.tasks.find_by_id(params[:id]) rescue NotFound
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
  
  def  generate_xls(data)
    capture = @current_school.captures.find_by_id(params[:id])
    tasks =  capture.tasks
    filepath="#{Merb.root}/tmp/#{@capture.title}.xls"
    test = Spreadsheet::Workbook.new
    sheet1 = test.create_worksheet
    style = xls_styles
    sheet1.column(0).width = 30
    
    r = 2 
    j = 1
    tasks.each do |f|
       sheet1.write(0, r, ["#{f.name}", "", ""], style[:merge_format])
       sheet1.write(1, 0, "Last Name", style[:answer_format])
       sheet1.write(1, 1, "First Name", style[:answer_format])
       sheet1.write(1, j+= 1, "Total Hours", style[:answer_format] )
       sheet1.write(1, j+= 1, "Hours", style[:answer_format] )
       sheet1.write(1, j+= 1, "Date", style[:answer_format] )
       sheet1.write(1, j+= 1, "Comments", style[:answer_format] )
       r += 4
    end
    
    total_hour = 2
    hour = 3
    date = 4 
    comment = 5
    person_id = []
    total = []
    tasks.each do |t|
       task_p = t.people_tasks.find(:all, :order => 'person_id DESC')
       task_p.each_with_index do |p, l|
         @hour_collection = t.people_tasks.find(:all, :conditions => ['person_id = ?', p.person_id]).collect{|x| x.hours}
         sum = 0
         @hour_collection.each {|m| sum = sum + m.to_f }
         unless person_id.include?(p.person_id)
           sheet1.write(l+2, 0, p.person.last_name, style[:parent])
           sheet1.write(l+2, 1, p.person.first_name, style[:parent])
         end
         unless total.include?(sum)
           sheet1.write(l+2, total_hour, sum)  
         end
         sheet1.write(l+2, hour, p.hours)
         sheet1.write(l+2, date, p.task_date)
         sheet1.write(l+2, comment, p.comments)
         person_id << p.person_id
         total << sum
       end
       total_hour += 4
       hour += 4 
       date += 4
       comment += 4
    end   
    
    test.write(filepath)
    filepath
  end

  def xls_styles
    styles={}
    styles[:answer_format] = Spreadsheet::Format.new :horizontal_align=>:CENTER,:color => 'white',:border =>false,:vertical_align=>:TOP,:size =>10,:text_wrap => :true,:vertical_align=>:TOP,:weight => :bold,:pattern => 2 ,:pattern_bg_color=> :blue
    styles[:parent] = Spreadsheet::Format.new :weight => :bold, :size => 12
    styles[:merge_format] = Spreadsheet::Format.new :weight => :bold, :size => 14, :align => :merge
    styles
  end
  
  
end