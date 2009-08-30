require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Students, "index action" do
  before(:each) do
    dispatch_to(Students, :index)
  end
end