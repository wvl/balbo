module Balbo
  # A ContextMiss is raised whenever a tag's target can not be found
  # in the current context if `Mustache#raise_on_context_miss?` is
  # set to true.
  #
  # For example, if your View class does not respond to `music` but
  # your template contains a `{{template}}` tag this exception will be raised.
  #
  # By default it is not raised. See Mustache.raise_on_context_miss.
  class ContextMiss < RuntimeError;  end

  # A Context represents the context which a Mustache template is
  # executed within. All Mustache tags reference keys in the Context.
  class Context
    def initialize(initial={})
      @stack = [initial]
      @raise_on_context_miss = false
    end
    
    def push(hash)
      @stack << hash
      self
    end
    
    def pop
      @stack.pop if @stack.size > 1
      self
    end
    
    def [](name)
      @stack.reverse_each do |hash|
        if hash.respond_to?(:has_key?) && hash.has_key?(name)
          return hash[name]
        elsif hash.respond_to?(:has_key?) && hash.has_key?(name.to_s)
          return hash[name.to_s]
        elsif hash.respond_to?(name)
          return hash.send(name)
        end
      end
      raise ContextMiss.new("Can't find #{name} in #{self.inspect}") if  @raise_on_context_miss
      ""
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
  
end
