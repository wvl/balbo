require File.dirname(__FILE__)+'/spec_helper'

describe "Template tokenize" do
  def t(s)
    Mustache::Template.new(s)
  end
  
  {
    "Hello World" => [[:text, "Hello World"]],
    "Hello {{ name }}" => [[:text, "Hello "], [:var, "name"]],
    "{if true }yes{/if}" => [[:if, "true"], [:text, "yes"], [:endif, nil]],
    "{{name}}{{ name}}{{ name }}{{name }}" => 4.times.map { [:var, "name"] },
    "{if true }yes{/if}" => [[:if, "true"], [:text, "yes"], [:endif, nil]],
    "{if true}yes{/if }" => [[:if, "true"], [:text, "yes"], [:endif, nil]],
    "{if true }yes{/if true }" => [[:if, "true"], [:text, "yes"], [:endif, nil]],
    "{if true }yes{/if random text}" => [[:if, "true"], [:text, "yes"], [:endif, nil]]
  }.each do |source, tokens|
    it "tokenize: #{source}" do
      t(source).tokenize.should == tokens
    end
  end
  
  it "should render a simple template" do
    t("Hello World").render.should == "Hello World"
  end
  
  it "should render a simple template with a var" do
    t("Hello {{ name }}").render({'name' => "Joe"}).should == "Hello Joe"
  end
  
  it "should render vars escaped" do
    t("<h1>{{title}}</h1>").render('title'=>"Bear > Shark").should == "<h1>Bear &gt; Shark</h1>"
  end

  it "should render vars unescaped with triple braces" do
    t("<body>{{{c}}}</body>").render('c'=>"<p>Content</p>").should == "<body><p>Content</p></body>"
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

  it "should work with a ruby object as context" do
    t("{{ user.name }}").render({'user'=>Struct.new(:name).new('John')}).should == "John"
  end
    
  it "should render nested if blocks" do
    t("{if true }yes{if hey}no{/if}yes{/if}").render({'hey'=>false}).should == "yesyes"
  end
  
  it "should render a loop" do
    t("{loop names}<li>{{ name }}</li>{/loop}").render({
     "names"=>[{'name'=>'John'},{'name'=>'Jane'}] }).should == "<li>John</li><li>Jane</li>"
  end
  
  it "should ignore comments" do
    t("{# comments go like this}hey").render.should == "hey"
  end
end