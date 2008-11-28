require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Calendar do

 
  before(:each) do
     @calendar = Calendar.new({:title => 'testing'})
     t = Time.parse('2006/05/01')
     @calendar.start_date = t
     @calendar.end_date = t
  end
  
  it "should be invalid without a Title" do
     @calendar.should be_valid
     @calendar.title = ''
     @calendar.should_not be_valid
     @calendar.errors.on(:title).should eql("can't be blank")
  end
  
  it "should be invalid with out a Start Date" do
     @calendar.should be_valid
     @calendar.start_date = ''
     @calendar.should_not be_valid
     @calendar.errors.on(:start_date).should eql("can't be blank")
   end    

   it "should be invalid with out a End Date" do
     @calendar.should be_valid
     @calendar.end_date = ''
     @calendar.should_not be_valid
     @calendar.errors.on(:end_date).should eql("can't be blank")
   end
   
       
   
end