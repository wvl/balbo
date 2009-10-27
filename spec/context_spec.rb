require File.dirname(__FILE__)+'/spec_helper'

include Balbo

describe "Context" do
  after do
    Balbo.lookup_stack = []
  end
  
  it "Should lookup things by path variable" do
    Context.new({"site"=>{'title'=>'My Site'}}).resolve('site.title').should == "My Site"
  end

  it "should provide a default lookup stack" do
    Balbo.lookup({'site'=>{'title'=>'My Site'}})
    Context.new().resolve('site.title').should == "My Site"
  end
  
  it "should lookup things from the top of the stack" do
    Balbo.lookup({"myname"=>"Joe"})
    Balbo.lookup({"myname"=>"Anna"})
    Context.new().resolve("myname").should == "Anna"
    Context.new({"myname"=>"Grace"}).resolve("myname").should == "Grace"
  end
end