$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'balbo'

class Simple
  def name
    "Chris"
  end

  def value
    10_000
  end

  def taxed_value
    value - (value * 0.4)
  end

  def in_ca
    true
  end
end

if $0 == __FILE__
  puts Balbo.render('simple', Simple.new, File.dirname(__FILE__))
end

__END__
Hello Chris
You have just won $10000!
Well, $6000.0, after taxes.
