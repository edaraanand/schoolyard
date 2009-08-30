require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe HomeWork do

  before(:each) do
    @home_work = HomeWork.new({:title => 'WASC', :content => 'We are in our 3rd week – the half way point – of our collection for the Yolo County Food Bank and you guys are doing a great job!'})
  end

   it "should be invalid without a Title" do
      @home_work.should be_valid
      @home_work.title = ''
      @home_work.should_not be_valid
      @home_work.errors.on(:title).should eql("can't be blank")
   end
   
   it "should be invalid without a Content" do
      @home_work.should be_valid
      @home_work.content = ''
      @home_work.should_not be_valid
      @home_work.errors.on(:content).should eql("can't be blank")
   end

end