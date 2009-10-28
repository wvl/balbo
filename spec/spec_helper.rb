ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bacon'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'balbo'

def t(s)
  Balbo::Template.new(s, File.dirname(__FILE__))
end

Bacon.summary_on_exit