$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'balbo'

module TestViews
  class Namespaced
    def title
      "Dragon < Tiger"
    end
  end
end


if $0 == __FILE__
  puts balbo('namespaced', TestViews::Namespaced.new, File.dirname(__FILE__))
end

__END__
<h1>Dragon &lt; Tiger</h1>
