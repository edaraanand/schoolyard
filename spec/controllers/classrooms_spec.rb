require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Classrooms, "index action" do
  before(:each) do
    dispatch_to(Classrooms, :index)
  end
end