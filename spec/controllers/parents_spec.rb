require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Parents, "index action" do
  before(:each) do
    dispatch_to(Parents, :index)
  end
end