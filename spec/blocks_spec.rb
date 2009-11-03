require File.dirname(__FILE__)+'/spec_helper'

describe "loop" do  
  it "should operate on a named var" do
    t("{loop links }{{name}}{/loop}").render( \
    {'links'=>[{'name'=>'1'},{'name'=>'2'}]}).should == "12"
  end
  
  it "should operate on the top of the stack if not named" do
    t("{loop}{{name}}{/loop}").render( \
      [{'name'=>'1'},{'name'=>'2'}]).should == "12"
  end
  
  it "should allow looping with a named variable" do
    t("{loop links as link}{{link}}{/loop}").render( \
      {'links'=>['1','2']}).should == "12"
  end
end
