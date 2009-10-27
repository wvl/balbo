$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'balbo'

class TemplatePartial
  
  def title
    "Welcome"
  end

  def title_bars
    '-' * title.size
  end
end

if $0 == __FILE__
  puts balbo('template_partial', TemplatePartial.new, File.dirname(__FILE__))
end

__END__
<h1>Welcome</h1>
Again, Welcome!
