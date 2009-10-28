require 'sinatra/base'
require 'balbo'

module Balbo
  class BalboTemplate < Tilt::Template     
    def compile!
      @engine = Balbo::Template.new(data, Balbo.template_path).compile
    end
    
    def evaluate(scope, locals={}, &block)
      @engine.render(locals[:context])
    end
  end

  module Sinatra
    module Templates
      #
      # Call this in your sinatra app to render a balbo template
      def balbo(template, locals=nil)
        Balbo.template_path = settings.views
        if options.namespace.const_defined?(:Views)
          mod = options.namespace::Views
          instance = Class.new
          instance.extend(mod)
          locals = instance.send(template, locals) if instance.respond_to?(template)
        end
        render :balbo, template, {}, {:context=>context(locals)}
      end

      # Add data to the lookup context
      def context(newlocals=nil)
        @balbo_context ||= Balbo::Context.new
        @balbo_context.push(newlocals) unless newlocals.nil?
        @balbo_context
      end
    end
    
    def self.registered(app)
      app.helpers Balbo::Sinatra::Templates
      app.set :namespace, app
    end
  end

end
Tilt.register 'balbo', Balbo::BalboTemplate
# Sinatra::Base.helpers Balbo::Sinatra::Templates
# Sinatra::Base.register Balbo::Sinatra



