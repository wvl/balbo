require File.dirname(__FILE__)+'/spec_helper'

describe "Context" do  
  it "Should lookup things by path variable" do
    Balbo::Context.new({"site"=>{'title'=>'My Site'}}).resolve('site.title').should == "My Site"
  end
end