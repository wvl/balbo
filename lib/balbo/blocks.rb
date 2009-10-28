module Balbo
  class Var
    def initialize(arglist, escaped=true)
      @var = arglist
      @escaped = escaped
    end
    
    def render(context)
      value = context.resolve(@var)
      @escaped ? CGI.escapeHTML(value.to_s) : value
    end
  end
  
  class If
    def initialize(data, template)
      @var = data
      was_else = false
      @body = template.compile { |token, data| 
        if [:endif, :else].include?(token) 
          was_else = token == :else
          true
        end
      }
      @else_body = template.compile { |token, data| token == :endif } if was_else
    end
    
    def render(context)
      cond = context.evaluate(@var)
      if cond && (!cond.respond_to?(:empty?) || !cond.empty?)
        @body.render(context)
      elsif @else_body
        @else_body.render(context)
      else
        ""
      end 
    end
  end
  
  class Loop
    def initialize(data, template)
      @var = data
      @nodes = template.compile { |token, data| token == :endloop }
    end
    
    def render(context)
      iterable = context.resolve(@var)
      length = 0

      if iterable.respond_to?(:each)
        length = iterable.size if iterable.respond_to?(:size)
        length = iterable.length if iterable.respond_to?(:length)
      end
      
      result = ""
      if length > 0
        iterable.each do |item|
          context.push(item)
          result << @nodes.render(context)
          context.pop
        end
      end
      result
    end
  end
  
  class Include
    def initialize(data, template)
      @nodes = template.load(data)
    end
    
    def render(context)
      @nodes.render(context)
    end
  end
  
  class Extends
    def initialize(data, template)
      @nodes = template.load(data).compile
      @main = template.compile
    end
    
    def render(context)
      @nodes.render(context)
    end
  end
  
  class Block
    def initialize(data, template)
      @name = data
      @template = template
      template.blocks[@name] = template.compile { |token, data| token == :endblock }
    end
    
    def render(context)
      @template.blocks[@name].render(context)
    end
  end
end