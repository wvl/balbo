require File.dirname(__FILE__)+'/spec_helper'

describe "Template tokenize" do
  {
    "Hello World" => [[:text, "Hello World"]],
    "Hello {{ name }}" => [[:text, "Hello "], [:var, "name"]],
    "{if true }yes{/if}" => [[:if, "true"], [:text, "yes"], [:endif, nil]]
  }.each do |source, tokens|
    it "tokenize: #{source}" do
      Mustache::Template.new(source).tokenize.should == tokens
    end
  end
  
  def t(s)
    Mustache::Template.new(s)
  end
  
  it "should render a simple template" do
    t("Hello World").render.should == "Hello World"
  end
  
  it "should render a simple template with a var" do
    t("Hello {{ name }}").render({'name' => "Joe"}).should == "Hello Joe"
  end
  
  it "should render a simple template with an if block" do
    t("{if true }yes{/if}").render({}).should == "yes"
    t("{if false }no{/if}").render({}).should == ""
    t("{if check }yes{/if}").render({'check'=>true}).should == "yes"
    t("{if x==3 }yes x is 3{/if}").render({'x'=>3}).should == "yes x is 3"
  end
  
  it "should output nested context vars" do
    t("{{ user.name }}").render({'user'=>{'name'=>'Joe'}}).should == "Joe"
  end
  
  class TestUser
    def initialize(name); @name = name; end
    def name; @name; end
  end
  
  it "should work with a ruby object as context" do
    t("{{ user.name }}").render({'user'=>TestUser.new('John')}).should == "John"
  end
    
  it "should render nested if blocks" do
    t("{if true }yes{if hey}no{/if}yes{/if}").render({'hey'=>false}).should == "yesyes"
  end
  
#   it "should tokenize templates" do
#     Mustache::Template.new("Hello world").tokenize.should == [[:text, "Hello world"]]
#   end  
end