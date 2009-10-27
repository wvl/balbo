$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'balbo'

class Unescaped
  
  def title
    "Bear > Shark"
  end
end

if $0 == __FILE__
  puts balbo('unescaped', Unescaped.new, File.dirname(__FILE__))
end

__END__
<h1>Bear > Shark</h1>
