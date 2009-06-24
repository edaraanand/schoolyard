class Ranks < Application
  
   layout 'default'
   before :access_rights
   before :find_school
   
   
  def index
    render
  end
  
  def new
    @rank = @current_school.ranks.new
    render
  end
  
  def create
     names = params[:rank][:name]
     from = params[:rank][:from]
     to = params[:rank][:to]
     s = names.zip(from, to)
     s.each do |l|
        Rank.create({:name => "#{l[0]}", :from => "#{l[1]}", :to => "#{l[2]}", :school_id => @current_school.id })
     end
     redirect resource(:reports) 
  end
  
  def edit
    @ranks = @current_school.ranks.find(:all)
    render
  end
  
  def update
    @ranks = @current_school.ranks.find(:all)
    @rank_id = @ranks.collect{|x| x.id }
    names = params[:rank][:name]
    from = params[:rank][:from]
    to = params[:rank][:to]
    s = names.zip(from, to, @rank_id)
    s.each do |l|
       if l[3].nil?
          Rank.create({:name => "#{l[0]}", :from => "#{l[1]}", :to => "#{l[2]}", :school_id => @current_school.id })
       else
          Rank.update(l[3], {:name => "#{l[0]}", :from => "#{l[1]}", :to => "#{l[2]}", :school_id => @current_school.id })
       end
    end
    redirect resource(:reports)
  end
  
  def delete
    raise "Eshwar".inspect
  end
  
  
   private
   
   def access_rights
      @selected = "grades"
      have_access = false
      @view = Access.find_by_name('view_all')
      @ann = Access.find_by_name('grades')
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
