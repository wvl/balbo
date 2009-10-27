$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'balbo'

class ViewPartial
  def greeting
    "Welcome"
  end

  def farewell
    "Fair enough, right?"
  end
end

if $0 == __FILE__
  puts balbo('view_partial', ViewPartial.new, File.dirname(__FILE__))
end

__END__
