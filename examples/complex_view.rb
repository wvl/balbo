$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'balbo'

class ComplexView 

  def header
    "Colors"
  end

  def items
    items = []
    items << { 'name' => 'red', 'current' => true, 'url' => '#Red' }
    items << { 'name' => 'green', 'current' => false, 'url' => '#Green' }
    items << { 'name' => 'blue', 'current' => false, 'url' => '#Blue' }
    items
  end
end

if $0 == __FILE__
  puts balbo('complex_view', ComplexView.new, File.dirname(__FILE__))
end

__END__
<h1>Colors</h1>
<ul>
  <li><strong>red</strong></li>
    <li><a href="#Green">green</a></li>
    <li><a href="#Blue">blue</a></li>
    </ul>


