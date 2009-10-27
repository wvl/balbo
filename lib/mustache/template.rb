require 'cgi'

class Mustache
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

    class Context
      def initialize(initial={})
        @stack = [initial]
      end
      
      def [](name)
        @stack.reverse_each do |hash|
          val = hash[name]
          return val if not val.nil?
        end
        nil
      end
      
      def has_key?(key)
        not send(:[], key).nil?
      end
      
      def resolve(path, from=self)
        path.to_s.split(/\./).each do |part|
          if from.respond_to?(:has_key?) and t = from[part]
            from = t
          elsif from.respond_to?(part)
            from = from.send(part)
          else
            return "" # Fail silently
          end
        end
        from
      end
      
      def evaluate(source)
        eval(source)
      end
      
      def method_missing(key, *args)
        resolve(key.to_s)
      end
    end
    
    class Var
      def initialize(arglist)
        @var = arglist
      end
      
      def render(context)
        context.resolve(@var)
      end
    end
    
    class If
      def initialize(data, template)
        @var = data
        @nodes = template.compile { |token, data| token == :endif }        
      end
      
      def render(context)
        result = ""
        cond = context.evaluate(@var)
        if cond && (!cond.respond_to?(:empty?) || !cond.empty?)
          @nodes.each do |node|
            result << (node.respond_to?(:render) ? node.render(context) : node)
          end
        end 
        result
      end
    end
    
    # Expects a Balbo template as a string along with a template
    # path, which it uses to find partials.
    def initialize(source, template_path = '.', template_extension = 'balbo')
      @source = source
      @template_path = template_path
      @template_extension = template_extension
      @tokens = nil
      @nodes = nil
      @tags = {
        :text => lambda { |token, data, t| data },
        :var => lambda { |token, data, t| Var.new(data) },
        :if => lambda { |token, data, t| If.new(data, t) }
      }
    end

    def tokens
      @tokens ||= tokenize
    end

    def compile(&block)
      nodes = []
      while !tokens.empty?
        token, data = tokens.shift
        
        #nodes << @tags[token].call(token, data, self) if @tags.has_key?(token)
        nodes << data if token == :text
        nodes << Var.new(data) if token == :var
        nodes << If.new(data, self) if token == :if
        return nodes if block_given? && block.call(token, data)
      end
      nodes
    end
    
    def tokenize
      regex = / \{\{(.*?)\}\} | \{if(.*?)\} | \{\/if(.*?)\} /xim
      result = []
      text = @source
      while text =~ regex
        result << [:text, $`] unless $`.empty?
        result << [:var, $1.strip] if $1
        result << [:if, $2.strip] if $2
        result << [:endif, nil] if $3
        text = $'
      end
      result << [:text, text] if not text.empty?
      result
    end
    
    def render(context={})
      
      result = ""
      context = Context.new(context)
      (@nodes ||= compile).each do |node|
        result << (node.respond_to?(:render) ? node.render(context) : node)
      end
      result
    end
    
    # Renders the `@source` Mustache template using the given
    # `context`, which should be a simple hash keyed with symbols.
    def renderit(context)
      # Compile our Mustache template into a Ruby string
      compiled = "def render(ctx) #{compile} end"

      # Here we rewrite ourself with the interpolated Ruby version of
      # our Mustache template so subsequent calls are very fast and
      # can skip the compilation stage.
      instance_eval(compiled, __FILE__, __LINE__ - 1)

      # Call the newly rewritten version of #render
      render(context)
    end

    # Does the dirty work of transforming a Mustache template into an
    # interpolation-friendly Ruby string.
#     def compile(src = @source)
#       "\"#{compile_sections(src)}\""
#     end

    # {{#sections}}okay{{/sections}}
    #
    # Sections can return true, false, or an enumerable.
    # If true, the section is displayed.
    # If false, the section is not displayed.
    # If enumerable, the return value is iterated over (a `for` loop).
    def compile_sections(src)
      res = ""
      while src =~ /#{otag}\#([^\}]*)#{ctag}\s*(.+?)#{otag}\/\1#{ctag}\s*/m
        # $` = The string to the left of the last successful match
        res << compile_tags($`)
        name = $1.strip.to_sym.inspect
        code = compile($2)
        ctxtmp = "ctx#{tmpid}"
        res << ev(<<-compiled)
        if v = ctx[#{name}]
          v = [v] if v.is_a?(Hash) # shortcut when passed a single hash
          if v.respond_to?(:each)
            #{ctxtmp} = ctx.dup
            begin
              r = v.map { |h| ctx.update(h); #{code} }.join
            rescue TypeError => e
              raise TypeError,
                "All elements in {{#{name.to_s[1..-1]}}} are not hashes!"
            end
            ctx.replace(#{ctxtmp})
            r
          else
            #{code}
          end
        end
        compiled
        # $' = The string to the right of the last successful match
        src = $'
      end
      res << compile_tags(src)
    end

    # Find and replace all non-section tags.
    # In particular we look for four types of tags:
    # 1. Escaped variable tags - {{var}}
    # 2. Unescaped variable tags - {{{var}}}
    # 3. Comment variable tags - {{! comment}
    # 4. Partial tags - {{< partial_name }}
    def compile_tags(src)
      res = ""
      while src =~ /#{otag}(#|=|!|<|\{)?(.+?)\1?#{ctag}+/
        res << str($`)
        case $1
        when '#'
          # Unclosed section - raise an error and
          # report the line number
          raise UnclosedSection.new(@source, $&, $2)
        when '!'
          # ignore comments
        when '='
          self.otag, self.ctag = $2.strip.split(' ', 2)
        when '<'
          res << compile_partial($2.strip)
        when '{'
          res << utag($2.strip)
        else
          res << etag($2.strip)
        end
        src = $'
      end
      res << str(src)
    end

    # Partials are basically a way to render views from inside other views.
    def compile_partial(name)
      klass = Mustache.classify(name)
      if Object.const_defined?(klass)
        ev("#{klass}.render")
      else
        src = File.read("#{@template_path}/#{name}.#{@template_extension}")
        compile(src)[1..-2]
      end
    end

    # Generate a temporary id, used when compiling code.
    def tmpid
      @tmpid += 1
    end

    # Get a (hopefully) literal version of an object, sans quotes
    def str(s)
      s.inspect[1..-2]
    end

    # {{ - opening tag delimiter
    def otag
      @otag ||= Regexp.escape('{{')
    end

    def otag=(tag)
      @otag = Regexp.escape(tag)
    end

    # }} - closing tag delimiter
    def ctag
      @ctag ||= Regexp.escape('}}')
    end

    def ctag=(tag)
      @ctag = Regexp.escape(tag)
    end

    # {{}} - an escaped tag
    def etag(s)
      ev("CGI.escapeHTML(ctx[#{s.strip.to_sym.inspect}].to_s)")
    end

    # {{{}}} - an unescaped tag
    def utag(s)
      ev("ctx[#{s.strip.to_sym.inspect}]")
    end

    # An interpolation-friendly version of a string, for use within a
    # Ruby string.
    def ev(s)
      "#\{#{s}}"
    end
  end
end
