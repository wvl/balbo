require 'balbo/template'
require 'balbo/context'
require 'balbo/blocks'

module Balbo
  # The template path controls where balbo templates are loaded from.
  # By default it's the current directory (".")
  def self.template_path
    @template_path ||= '.'
  end

  def self.template_path=(path)
    @template_path = File.expand_path(path)
    @template = nil
  end

  # Should an exception be raised when we cannot find a corresponding method
  # or key in the current context? By default this is false to emulate ctemplate's
  # behavior, but it may be useful to enable when debugging or developing.
  #
  # If set to true and there is a context miss, `Mustache::ContextMiss` will
  # be raised.
  def self.raise_on_context_miss?
    @raise_on_context_miss ||= false
  end

  def self.raise_on_context_miss=(boolean)
    @raise_on_context_miss = boolean
  end

  # Helper method for loading and rendering a balbo template
  def self.render(template, context, path=self.template_path, extension='balbo')
    Balbo::Template.load(template, path, extension).render(context)
  end
end