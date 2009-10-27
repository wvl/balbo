require File.dirname(__FILE__)+'/spec_helper'

def exampledir(file=nil, ext="rb")
  File.dirname(__FILE__)+"/../examples"+(file.nil? ? "" : "/#{file}.#{ext}")
end

$LOAD_PATH.unshift exampledir
require 'simple'
require 'namespaced'
require 'complex_view'
# require 'view_partial'
require 'template_partial'
require 'escaped'
require 'unescaped'
require 'comments'
require 'passenger'
require 'double_section'
require 'inheritance'

describe "Examples" do
  def sample(file)
    File.read(exampledir(file)).gsub("\r\n", "\n").split(/^__END__$/)[1].strip
  end
  
  {
    'simple' => Simple.new,
    'namespaced' => TestViews::Namespaced.new,
    'escaped' => Escaped.new,
    'unescaped' => Unescaped.new,
    'complex_view' => ComplexView.new,
    'comments' => Comments.new,
    'double_section' => DoubleSection.new,
    'template_partial' => TemplatePartial.new,
    'inheritance' => {'title'=>'My Page'}
  }.each { |name, context|
    it "should render #{name} example" do
      balbo(name, context, exampledir).strip.should == sample(name)
    end
  }
  
  it "should render passenger example" do
    balbo('passenger', Passenger.new, exampledir, 'conf').strip.should == sample('passenger')
  end
end
