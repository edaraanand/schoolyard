require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Homes, "index action" do
  before(:each) do
    dispatch_to(Homes, :index)
  end
end