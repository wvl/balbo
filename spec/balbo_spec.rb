require File.dirname(__FILE__)+'/spec_helper'

describe "Balbo render" do
  it "should render text with no arguments" do
    Mustache.render('Hello World!').should == 'Hello World!'
  end
  
  it "should render text with a param block" do
    Mustache.render('Hello {{planet}}!', :planet => 'World').should == 'Hello World!'
  end
  
  it "should render text with an if block" do
    Mustache.render('Hello {if true}World!{/if}').should == "Hello World!"
  end
end