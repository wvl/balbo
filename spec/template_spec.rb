require File.dirname(__FILE__)+'/spec_helper'

describe "Template tokenize" do  
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

end  

describe "Template render" do
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
    t("{if american}yes{/if}").render.should == ""
  end
  
  it "should render an else block" do
    t("{if false}no{else}yes{/if}").render.should == "yes"
  end
  
  it "should not supress whitespace" do
    t(<<-ENDTEMPLATE).render.should == "      Yes\n      "
      {if true}
        Yes
      {/if}
ENDTEMPLATE
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
  
  it "should render a complex loop" do
    t("{loop items }{if current}<li>{{name}}</li>{/if current}{/loop items }").render({
        'items' => [
         { 'name' => 'red', 'current' => true, :url => '#Red' },
         { :name => 'green', :current => false, :url => '#Green' },
         { :name => 'blue', :current => false, :url => '#Blue' }
        ]   
    }).should == "<li>red</li>"
  end
  
  it "should ignore comments" do
    t("{# comments go like this}hey").render.should == "hey"
  end
  
  it "should be able to parse and load a template" do
    t("").load("test").render.should == "Just a test"
  end
  
  it "should load a template with the class method" do
    Balbo::Template.load("test", File.dirname(__FILE__)).render.should == "Just a test"
  end
  
  it "should include a partial" do
    t("{include test }").render.should == "Just a test"
  end
  
  it "should keep rendering after the partial" do
    t("{{ one }}{include test }{{ two }}").render({"one"=>"1. ", "two"=>" 2."}).should == \
      "1. Just a test 2."
  end
  
  it "should render with inheritance" do
    t("{extends layout }{block main }Hi{/block}").render('title'=>"Hello World").strip.should == <<-TMPL.strip
<title>Hello World</title>
Hi
TMPL
  end
  
  it "should render with inheritance two" do
    t("{extends layout }{block main }Hi{/block}{block title}My {{ title }}{/block}").render('title'=>"Hello World").strip.should == <<-TMPL.strip
<title>My Hello World</title>
Hi
TMPL
  end
  
  it "should render with inheritance and includes" do
    t("{extends layout}{block main}{include test}{/block}") \
      .render('title'=>'Hi', 'canadian'=>true).strip.should == <<-TMPL.strip
<title>Hi</title>
Just a test, eh?
TMPL
  end
      
    

end