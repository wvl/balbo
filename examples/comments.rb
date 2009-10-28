$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'balbo'

class Comments
  def title
    "A Comedy of Errors"
  end
end

if $0 == __FILE__
  puts Balbo.render('comments', Comments.new, File.dirname(__FILE__))
end

__END__
<h1>A Comedy of Errors</h1>

