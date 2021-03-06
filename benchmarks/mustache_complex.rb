$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'mustache'

class MustacheComplex < Mustache
  self.path = File.dirname(__FILE__)

  def header
    "Colors"
  end

  def item
    items = []
    items << { :name => 'red', :current => true, :url => '#Red' }
    items << { :name => 'green', :current => false, :url => '#Green' }
    items << { :name => 'blue', :current => false, :url => '#Blue' }
    items
  end

  def link
    not context[:current]
  end

  def list
    not item.empty?
  end

  def empty
    item.empty?
  end
end

if $0 == __FILE__
  puts MustacheComplex.to_html
end
