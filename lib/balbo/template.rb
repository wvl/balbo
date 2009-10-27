require 'cgi'

module Balbo
  # A Template is a compiled version of a Mustache template.
  #
  # Tokenize the text stream, then parse the token sequence
  #
  # You shouldn't use this class directly.
  class Template
    # An UnclosedSection error is thrown when a {{# section }} is not
    # closed.
    #
    # For example:
    #   {{# open }} blah {{/ close }}
    class UnclosedSection < RuntimeError
      attr_reader :message

      # Report the line number of the offending unclosed section.
      def initialize(source, matching_line, unclosed_section)
        num = 0

        source.split("\n").each_with_index do |line, i|
          num = i + 1
          break if line.strip == matching_line.strip
        end

        @message = "line #{num}: ##{unclosed_section.strip} is not closed"
      end
    end
        
    def self.load(name, template_path='.', template_extension='balbo')
      new(File.read("#{template_path}/#{name}.#{template_extension}"), 
        template_path, template_extension)
    end
    
    # Expects a Balbo template as a string along with a template
    # path, which it uses to find partials.
    def initialize(source="", template_path = '.', template_extension = 'balbo')
      @source = source
      @template_path = template_path
      @template_extension = template_extension
      @tokens = nil
      @nodes = nil
      @blocks = {}
      @tags = {
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
    end

    def blocks
      @blocks
    end
    
    def blocks=(blocks)
      @blocks = blocks
    end
    
    def load(name)
      newtemplate = self.class.new(File.read("#{@template_path}/#{name}.#{@template_extension}"), \
        @template_path, @template_extension)
      newtemplate.blocks = self.blocks
      newtemplate
    end
      
    def nodelist(nodes)
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
        nodes << @tags[token].call(token, data, self) if @tags.has_key?(token)
        break if block_given? && block.call(token, data)
      end
      nodelist(nodes)
    end
    
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
    
    def render(context={})
      nodes.render(Context.new(context))
    end    
  end
end
