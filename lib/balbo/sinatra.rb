require 'sinatra/base'
require 'balbo'

module Balbo
  class BalboTemplate < Tilt::Template     
    def compile!
      @engine = Balbo::Template.new(data, Balbo.template_path).compile
    end
    
    def evaluate(scope, locals={}, &block)
      @engine.render(Context.new(locals))
    end
  end
end
Tilt.register 'balbo', Balbo::BalboTemplate

module Sinatra
  module Templates
    def balbo(template, locals={})
      Balbo.template_path = settings.views
      render :balbo, template, {}, locals
    end
  end
end

