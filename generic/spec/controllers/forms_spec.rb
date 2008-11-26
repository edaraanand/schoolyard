require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Forms, "index action" do
  before(:each) do
    dispatch_to(Forms, :index)
  end
end