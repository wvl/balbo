Balbo
=====

Balbo, is a fork and almost complete rewrite of [Mustache][1]. It attempts
to take the best aspects of Mustache, Django Templates, and ERB, and mash 
them together.

Why?
----

I'm with defunkt when he says:

> I like writing Ruby. I like writing HTML. I like writing JavaScript.
>
> I don't like writing ERB, Haml, Liquid, Django Templates, putting Ruby
> in my HTML, or putting JavaScript in my HTML.

I thought Mustache was quite interesting when I saw it. However, I have to 
ammend the quote above, and say that "I'm not sure that I like writing mustache" either.

Some of the things I did not like about Mustache were:

### 1. The same block tag for conditionals and loops

It's an interesting idea, but it makes understanding the intent of a
template difficult. You have to understand what the variable is returning,
(Is it a list? or a boolean?) to understand how the template will render.
Having different tags for conditionals and loops makes the intent clear.

### 2. No logic in the templates. none.

This is a great principle, but not very pragmatic. Specifically, it requires
writing code such as:

    def no_next_hurl_and_anonymous
      no_next_hurl && !logged_in?
    end
    
    {{# no_nex_hurl_and_anonymous}}
      <a href="/" style="display:none;" id="page-next" title="next">&rang;</a>
    {{/ no_next_hurl_and_anonymous }}

when that check would be simpler and more clear if written in the template
itself.

### 3. Pulling in locals and instance methods from your controllers

This has been a pet peeve of mine from back in the Rails 1.0 days, and I'm
disgruntled to see that persisting with modern Sinatra apps. I think the 
alternative I'm proposing in Balbo is better. A lookup stack that data can
be pushed onto, and passing data directly to the template.

### Other changes

Since I was making sweeping changes to Mustache, I decided to incorporate
other changes, and not be limited to the goals of Mustache (such as 
remaining somewhat compatible with ctemplate et al.) Therefore, I've
also made changes, such as:

* Use tag names instead of characters, and one brace instead of two.
* Closing tags do not need to match the opening tag exactly.

    {if check}My template{/if}   instead of
    {# check}My tempalate{/# check}

### Inspiration from Django

The template system of content blocks and inheritance is a powerful one.
I've integrated it into Balbo.

Overview
--------

A Balbo view consists of traditional template. Any logic, modules, etc. are
pushed onto the context in your app. The only logic allowed in the 
template itself are in the conditional statements.

Usage
-----

Quick example:

    >> require 'balbo'
    => true
    >> Balbo::Template.new("Hello {{planet}}").render({:planet => "World!"})
    => "Hello World!"

We've got an `examples` folder but here's the canonical one:

    class Simple
      def name
        "Chris"
      end

      def value
        10_000
      end

      def taxed_value
        value - (value * 0.4)
      end

      def in_ca
        true
      end
    end

We have a class that we want to reference in our template. Some methods
reference others, some return values, some return only booleans.

Now let's write the template:

    Hello {{name}}
    You have just won ${{value}}!
    {if in_ca }
    Well, ${{taxed_value}}, after taxes.
    {/if in_ca}

This template references the object we will put into the lookup context.
Here's the code to render actual HTML;

    Balbo.render('simple', Simple.new)

Which returns the following:

    Hello Chris
    You have just won $10000!
    Well, $6000.0, after taxes.

Simple.


Tag Types
---------

Tags are indicated by braces, either double (or triple) braces for variables, or an opening brace and tag name. `{{name}}` and `{loop }` are tags. Let's
talk about the different types of tags.

### Variables

The most basic tag is the variable. A `{{name}}` tag in a basic
template will try to lookup the `name` method in the lookup context. It will
start from the top of the stack and check if `name` exists, either as a 
method or a hash key. If it does not exist, it will search down the context
stack. If it reaches the bottom of the context stack without finding 
`name`, and empty string will be returned.

All variables are HTML escaped by default. If you want to return
unescaped HTML, use the triple mustache: `{{{name}}}`.

By default a variable "miss" returns an empty string. You can
configure this by setting `Mustache.raise_on_context_miss` to true.

### if/esle

The conditional statement will be `eval`'d in the context of the 
template context. If it evaluates to something other than false, nil or
an empty string (unlike ruby, we evaluate an empty string to false, since
the default context lookup of a missing variable returns an empty string) then the template between the {if} and the {/if} (or {/else}) will be rendered.

An `{else}` tag is optional:

    {if link == "/about" }
      <h1>About Us</h1>
    {else}
      <h1>Something Else</h1>
    {/if}

### loop

The loop tag lets you loop over a sequence. It expects an iterable to be
returned. Each item is popped onto the context.

For example, imagine this template:

    {loop repo}
      <b>{{name}}</b>
    {/loop}

And this view code:

    def repo
      Repository.all.map { |r| { :name => r.to_s } }
    end

When rendered, our view will contain a list of all repository names in
the database.

### include

You can include a template into the current template with the include tag.
The current context is used for rendering the included template.

    {include subtemplate }


### extends

Template inheritance lets you define a base template that you can then 
override in the child templates. Extends is the tag to define the parent
template.

    {extends layout }


### block

Block sections define an overridable content area. So, a layout can define default content for a block, which is then overrided by the rendered 
template.

For example, given this file layout.balbo:

    {block header}
      <h1>Layout Title</h1>
    {/block}

With this template:

    {extends layout}
    {block header}
      <h1>This is my header</h1>
    {/block}

Would render:

    <h1>This is my header</h1>

### Comments

Comments begin with a # and are ignored. The following template:

    <h1>Today{# ignore me }.</h1>

Will render as follows:

    <h1>Today.</h1>


Templates
---------

You can set the search path using `Balbo.template_path`.

    Balbo.template_path = File.dirname(__FILE__)

Balbo also allows you to define the extension it'll use with 
`Balbo.template_extension`.

    Balbo.template_extension = 'html'


Views
-----


Mustache supports a bit of magic when it comes to views. If you're
authoring a plugin or extension for a web framework (Sinatra, Rails,
etc), check out the `view_namespace` and `view_path` settings on the
`Mustache` class. They will surely provide needed assistance.


Helpers
-------

The sinatra integration provides a helper method for adding items to the
lookup context. Add any helpers you want accessible in your views
there.

For Example:

    module ViewHelpers
      def gravatar(email, size = 30)
        gravatar_id = Digest::MD5.hexdigest(email.to_s.strip.downcase)
        gravatar_for_id(gravatar_id, size)
      end

      def gravatar_for_id(gid, size = 30)
        "#{gravatar_host}/avatar/#{gid}?s=#{size}"
      end

      def gravatar_host
        @ssl ? 'https://secure.gravatar.com' : 'http://www.gravatar.com'
      end
    end

Then just include it:

    class GlobalHelpers
      include ViewHelpers
      def initialize(ssl = false)
        @ssl = ssl
      end
    end
    
    class App < Sinatra::Default
      register Balbo::Sinatra
    
      before do
        context GlobalHelpers.new()
      end
    end

This is just ruby, so you can set up your context as you need it.


Sinatra
-------

Balbo ships with Sinatra integration. You can see the example sinatra
app in examples/app.

Document the View module integration here.


Installation
------------

### [Gemcutter](http://gemcutter.org/)

    $ gem install balbo

Acknowledgements
----------------

Thanks to [Chris Wanstrath](http://github.com/defunkt) for mustache.

Meta
----

* Code: `git clone git://github.com/wvl/balbo.git`
* Home: <http://github.com/wvl/balbo>

[1]: http://github.com/defunkt/mustache
