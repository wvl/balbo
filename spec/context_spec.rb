require File.dirname(__FILE__)+'/spec_helper'

describe "Context" do  
  it "Should lookup things by path variable" do
    Balbo::Context.new({"site"=>{'title'=>'My Site'}}).resolve('site.title').should == "My Site"
  end

  it "Should return an empty string if raise_on_context_miss is not set" do
    Balbo::Context.new({"test"=>"one"}).resolve("missing").should == ""
  end
  
  it "Should raise error if raise_on_context_miss is set" do
    Balbo.raise_on_context_miss = true
    lambda { Balbo::Context.new({"test"=>"one"}).resolve("missing") }. \
      should.raise(Balbo::ContextMiss)
    Balbo.raise_on_context_miss = false
  end
  
end