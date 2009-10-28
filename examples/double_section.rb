$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'balbo'

class DoubleSection
  
  def truth_check
    true
  end

  def two
    "second"
  end
end


if $0 == __FILE__
  puts Balbo.render('double_section', DoubleSection.new, File.dirname(__FILE__))
end

__END__
* first
* second
* third
