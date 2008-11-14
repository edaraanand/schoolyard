require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe HomeWorks, "index action" do
  before(:each) do
    dispatch_to(HomeWorks, :index)
  end
end