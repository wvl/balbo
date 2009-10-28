$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'balbo'

class Escaped
  
  def title
    "Bear > Shark"
  end
end

if $0 == __FILE__
  puts Balbo.render('escaped', Escaped.new, File.dirname(__FILE__))
end

__END__
<h1>Bear &gt; Shark</h1>
