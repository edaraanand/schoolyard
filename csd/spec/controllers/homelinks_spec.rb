require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Homelinks, "index action" do
  before(:each) do
    dispatch_to(Homelinks, :index)
  end
end