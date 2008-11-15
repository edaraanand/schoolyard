require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Approvals, "index action" do
  before(:each) do
    dispatch_to(Approvals, :index)
  end
end