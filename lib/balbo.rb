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

  # Helper method for loading and rendering a balbo template
  def self.render(template, context, path=self.template_path, extension='balbo')
    Balbo::Template.load(template, path, extension).render(context)
  end
end