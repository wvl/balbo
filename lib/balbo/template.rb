module Balbo
  # A Template is the main Balbo template
  # 
  # A template gets rendered by:
  #  1. Tokenizing the text stream, into atoms 
  #  2. Compiling the atoms into an array of blocks (nodes). 
  #  3. These nodes are then given a context of data, which transforms the template into 
  #     its output text.
  #
  class Template
    # Load and instantiate a balbo template
    def self.load(name, template_path='.', template_extension='balbo')
      new(File.read("#{template_path}/#{name}.#{template_extension}"), 
        template_path, template_extension)
    end
    
    TAGS = {
      :text => lambda { |token, data, t| data },
      :var => lambda { |token, data, t| Var.new(data) },
      :unvar => lambda { |token, data, t| Var.new(data, false) },
      :if => lambda { |token, data, t| If.new(data, t) },
      :loop => lambda { |token, data, t| Loop.new(data, t) },
      :include => lambda { |token, data, t| Include.new(data, t) },
      :extends => lambda { |token, data, t| Extends.new(data, t) },
      :block => lambda { |token, data, t| Block.new(data, t) },
      :comment => lambda { |to,d,t| ""}      
    }
    
    # Expects a Balbo template as a string along with a template
    # path, which it uses to find parent and child templates (partials).
    def initialize(source="", template_path = '.', template_extension = 'balbo')
      @source = source
      @template_path = template_path
      @template_extension = template_extension
    end

    # A hash of {block names => nodes} is used for the inheritance hierarchy.
    # The parent layout defines certain blocks, which the child layout then overrides.
    def blocks
      @blocks ||= {}
    end
    
    def blocks=(blocks)
      @blocks = blocks
    end
    
    # Include a sub template (partial) -- the blocks hash stays the same for both templates
    def load(name)
      newtemplate = self.class.load(name, @template_path, @template_extension)
      newtemplate.blocks = self.blocks
      newtemplate
    end
      
    def nodelist(nodes)
      # Define a render method on the array of nodes instance
      def nodes.render(context=Context.new({}))
        result = ""
        self.each do |node|
          result << (node.respond_to?(:render) ? node.render(context) : node)
        end
        result
      end
      nodes
    end
    
    def tokens
      @tokens ||= tokenize
    end
    
    def nodes
      @nodes ||= compile
    end

    def compile(tokens=tokens, &block)
      nodes = []
      while !tokens.empty?
        token, data = tokens.shift
        nodes << TAGS[token].call(token, data, self) if TAGS.has_key?(token)
        break if block_given? && block.call(token, data)
      end
      nodelist(nodes)
    end

    def render(context={})
      nodes.render(Context.new(context))
    end    
    
    # Internal method -- tokenize the source template
    def tokenize(source=@source)
      regex = / \{\{(\{?)(.*?)\}?\}\} |                     # {{ var }}, or {{{ var }}} 1,2
                \{(\#|if|else|loop|include|extends|block)(.*?)\}\s* |  # {if expression }  3,4
                \{\/(if|loop|block)(.*?)\}\s*/xim             # {/if closing expression } 5,6
      result = []
      text = source
      while text =~ regex
        result << [:text, $`] unless $`.empty? # prematch
        result << [:var, $2.strip] if $2 and $1 != "{"
        result << [:unvar, $2.strip] if $2 and $1=="{"
        result << [($3=="#" ? :comment : $3.to_sym), $4.strip] if $3
        result << ["end#{$5}".to_sym, nil] if $5
        text = $' # postmatch
      end
      result << [:text, text] if not text.empty?
      result
    end
    
  end
end
