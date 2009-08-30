require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Classroom do

  before(:each) do
    @classroom = Classroom.new({:class_name => 'test_class'})
  end
  
   it "should be invalid without a Class Name" do
     @classroom.should be_valid
     @classroom.class_name = ''
     @classroom.should_not be_valid
     @classroom.errors.on(:class_name).should eql("can't be blank")
   end

end