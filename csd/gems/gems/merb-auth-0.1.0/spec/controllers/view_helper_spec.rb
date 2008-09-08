require File.dirname(__FILE__) + '/../spec_helper'

module MerbAuth
  class Main < Application
    def index
      'index'
    end
  end
end

describe "MerbAuth::Main (controller)" do
  before :all do
    Merb::Router.prepare { |r| r.add_slice(:MerbAuth) } if standalone?
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(MerbAuth::Main, :index)
    controller.public_path_for(:image).should == "/slices/merb-auth/images"
    controller.public_path_for(:javascript).should == "/slices/merb-auth/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/merb-auth/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    MerbAuth::Main._template_root.should == MerbAuth.dir_for(:view)
    MerbAuth::Main._template_root.should == MerbAuth::Application._template_root
  end
end