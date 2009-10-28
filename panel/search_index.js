var search_data = {"index":{"searchIndex":["mustache","context","contextmiss","sinatra","helpers","template","unclosedsection","object","rack","bug","mustachepanel","view","[]()","[]()","[]()","[]=()","classify()","compile()","compile_partial()","compile_sections()","compile_tags()","compiled?()","compiled?()","content()","context()","ctag()","ctag=()","etag()","ev()","heading()","mustache()","name()","new()","new()","new()","otag()","otag=()","path()","path=()","raise_on_context_miss=()","raise_on_context_miss?()","raise_on_context_miss?()","registered()","render()","render()","render()","render()","render_mustache()","reset()","str()","template()","template()","template=()","template=()","template_extension()","template_extension=()","template_file()","template_file=()","template_path()","template_path=()","templateify()","templateify()","times()","times()","tmpid()","to_html()","to_html()","to_text()","to_text()","underscore()","utag()","variables()","variables()","view_class()","view_namespace()","view_namespace=()","view_path()","view_path=()","contributors","history.md","license","readme.md","readme.md","mustache.rb","context.rb","sinatra.rb","template.rb","version.rb","mustache_panel.rb","mustache_extension.rb","view.mustache"],"longSearchIndex":["lib/mustache.rb","mustache","mustache","mustache","mustache::sinatra","mustache","mustache::template","lib/rack/bug/panels/mustache_panel/mustache_extension.rb","lib/rack/bug/panels/mustache_panel.rb","rack","rack::bug","rack::bug::mustachepanel","mustache","mustache::context","object","mustache","mustache","mustache::template","mustache::template","mustache::template","mustache::template","mustache","mustache","rack::bug::mustachepanel","mustache","mustache::template","mustache::template","mustache::template","mustache::template","rack::bug::mustachepanel","mustache::sinatra::helpers","rack::bug::mustachepanel","mustache::context","mustache::template","mustache::template::unclosedsection","mustache::template","mustache::template","mustache","mustache","mustache","mustache","mustache","mustache::sinatra","mustache","mustache","mustache::template","object","mustache::sinatra::helpers","rack::bug::mustachepanel","mustache::template","mustache","mustache","mustache","mustache","mustache","mustache","mustache","mustache","mustache","mustache","mustache","mustache","rack::bug::mustachepanel","rack::bug::mustachepanel::view","mustache::template","mustache","mustache","mustache","mustache","mustache","mustache::template","rack::bug::mustachepanel","rack::bug::mustachepanel::view","mustache","mustache","mustache","mustache","mustache","files/contributors.html","files/history_md.html","files/license.html","files/readme_md.html","files/readme_md.html","files/lib/mustache_rb.html","files/lib/mustache/context_rb.html","files/lib/mustache/sinatra_rb.html","files/lib/mustache/template_rb.html","files/lib/mustache/version_rb.html","files/lib/rack/bug/panels/mustache_panel_rb.html","files/lib/rack/bug/panels/mustache_panel/mustache_extension_rb.html","files/lib/rack/bug/panels/mustache_panel/view_mustache.html"],"info":[["Mustache","lib/mustache.rb","classes/Mustache.html"," < Object","Mustache is the base class from which your Mustache subclasses should inherit (though it can be used",1],["Context","Mustache","classes/Mustache/Context.html"," < Hash","A Context represents the context which a Mustache template is executed within. All Mustache tags reference",1],["ContextMiss","Mustache","classes/Mustache/ContextMiss.html"," < RuntimeError","A ContextMiss is raised whenever a tag's target can not be found in the current context if `Mustache#raise_on_context_miss?`",1],["Sinatra","Mustache","classes/Mustache/Sinatra.html"," < ","Support for Mustache in your Sinatra app. require 'mustache/sinatra' class Hurl < Sinatra::Base register",1],["Helpers","Mustache::Sinatra","classes/Mustache/Sinatra/Helpers.html"," < ","",1],["Template","Mustache","classes/Mustache/Template.html"," < Object","A Template is a compiled version of a Mustache template. The idea is this: when handed a Mustache template,",1],["UnclosedSection","Mustache::Template","classes/Mustache/Template/UnclosedSection.html"," < RuntimeError","An UnclosedSection error is thrown when a {{# section }} is not closed. For example: {{# open }} blah",1],["Object","lib/rack/bug/panels/mustache_panel/mustache_extension.rb","classes/Object.html"," < Object","",1],["Rack","lib/rack/bug/panels/mustache_panel.rb","classes/Rack.html"," < ","",1],["Bug","Rack","classes/Rack/Bug.html"," < ","",1],["MustachePanel","Rack::Bug","classes/Rack/Bug/MustachePanel.html"," < Panel","MustachePanel is a Rack::Bug panel which tracks the time spent rendering Mustache views as well as all",1],["View","Rack::Bug::MustachePanel","classes/Rack/Bug/MustachePanel/View.html"," < Mustache","The view is responsible for rendering our panel. While Rack::Bug takes care of the nav, the content rendered",1],["[]","Mustache","classes/Mustache.html#M000053","(key)","Context accessors. view = Mustache.new view[:name] = \"Jon\" view.template = \"Hi, {{name}}!\" view.render",2],["[]","Mustache::Context","classes/Mustache/Context.html#M000003","(name)","",2],["[]","Object","classes/Object.html#M000026","(name)","",2],["[]=","Mustache","classes/Mustache.html#M000054","(key, value)","",2],["classify","Mustache","classes/Mustache.html#M000045","(underscored)","template_partial => TemplatePartial ",2],["compile","Mustache::Template","classes/Mustache/Template.html#M000008","(src = @source)","Does the dirty work of transforming a Mustache template into an interpolation-friendly Ruby string. ",2],["compile_partial","Mustache::Template","classes/Mustache/Template.html#M000011","(name)","Partials are basically a way to render views from inside other views. ",2],["compile_sections","Mustache::Template","classes/Mustache/Template.html#M000009","(src)","{{#sections}}okay{{/sections}} Sections can return true, false, or an enumerable. If true, the section",2],["compile_tags","Mustache::Template","classes/Mustache/Template.html#M000010","(src)","Find and replace all non-section tags. In particular we look for four types of tags: 1. Escaped variable",2],["compiled?","Mustache","classes/Mustache.html#M000044","()","Has this instance or its class already compiled a template? ",2],["compiled?","Mustache","classes/Mustache.html#M000043","()","Has this template already been compiled? Compilation is somewhat expensive so it may be useful to check",2],["content","Rack::Bug::MustachePanel","classes/Rack/Bug/MustachePanel.html#M000065","()","The content of our Rack::Bug panel ",2],["context","Mustache","classes/Mustache.html#M000052","()","A helper method which gives access to the context at a given time. Kind of a hack for now, but useful",2],["ctag","Mustache::Template","classes/Mustache/Template.html#M000016","()","}} - closing tag delimiter ",2],["ctag=","Mustache::Template","classes/Mustache/Template.html#M000017","(tag)","",2],["etag","Mustache::Template","classes/Mustache/Template.html#M000018","(s)","{{}} - an escaped tag ",2],["ev","Mustache::Template","classes/Mustache/Template.html#M000020","(s)","An interpolation-friendly version of a string, for use within a Ruby string. ",2],["heading","Rack::Bug::MustachePanel","classes/Rack/Bug/MustachePanel.html#M000064","()","The string used for our tab in Rack::Bug's navigation bar ",2],["mustache","Mustache::Sinatra::Helpers","classes/Mustache/Sinatra/Helpers.html#M000001","(template, options={}, locals={})","Call this in your Sinatra routes. ",2],["name","Rack::Bug::MustachePanel","classes/Rack/Bug/MustachePanel.html#M000063","()","The name of this Rack::Bug panel ",2],["new","Mustache::Context","classes/Mustache/Context.html#M000000","(mustache)","",2],["new","Mustache::Template","classes/Mustache/Template.html#M000006","(source, template_path = '.', template_extension = 'mustache')","Expects a Mustache template as a string along with a template path, which it uses to find partials. ",2],["new","Mustache::Template::UnclosedSection","classes/Mustache/Template/UnclosedSection.html#M000005","(source, matching_line, unclosed_section)","Report the line number of the offending unclosed section. ",2],["otag","Mustache::Template","classes/Mustache/Template.html#M000014","()","{{ - opening tag delimiter ",2],["otag=","Mustache::Template","classes/Mustache/Template.html#M000015","(tag)","",2],["path","Mustache","classes/Mustache.html#M000028","()","Alias for `template_path` ",2],["path=","Mustache","classes/Mustache.html#M000029","(path)","Alias for `template_path` ",2],["raise_on_context_miss=","Mustache","classes/Mustache.html#M000042","(boolean)","",2],["raise_on_context_miss?","Mustache","classes/Mustache.html#M000051","()","Instance level version of `Mustache.raise_on_context_miss?` ",2],["raise_on_context_miss?","Mustache","classes/Mustache.html#M000041","()","Should an exception be raised when we cannot find a corresponding method or key in the current context?",2],["registered","Mustache::Sinatra","classes/Mustache/Sinatra.html#M000004","(app)","",2],["render","Mustache","classes/Mustache.html#M000055","(data = template, ctx = {})","Parses our fancy pants template file and returns normal file with all special {{tags}} and {{#sections}}replaced{{/sections}}.",2],["render","Mustache","classes/Mustache.html#M000022","(*args)","Helper method for quickly instantiating and rendering a view. ",2],["render","Mustache::Template","classes/Mustache/Template.html#M000007","(context)","Renders the `@source` Mustache template using the given `context`, which should be a simple hash keyed",2],["render","Object","classes/Object.html#M000021","(*args, &block)","",2],["render_mustache","Mustache::Sinatra::Helpers","classes/Mustache/Sinatra/Helpers.html#M000002","(template, data, opts, locals, &block)","This is called by Sinatra's `render` with the proper paths and, potentially, a block containing a sub-view",2],["reset","Rack::Bug::MustachePanel","classes/Rack/Bug/MustachePanel.html#M000060","()","Clear out our page load-specific variables. ",2],["str","Mustache::Template","classes/Mustache/Template.html#M000013","(s)","Get a (hopefully) literal version of an object, sans quotes ",2],["template","Mustache","classes/Mustache.html#M000049","()","The template can be set at the instance level. ",2],["template","Mustache","classes/Mustache.html#M000034","()","The template is the actual string Mustache uses as its template. There is a bit of magic here: what we",2],["template=","Mustache","classes/Mustache.html#M000035","(template)","",2],["template=","Mustache","classes/Mustache.html#M000050","(template)","",2],["template_extension","Mustache","classes/Mustache.html#M000030","()","A Mustache template's default extension is 'mustache' ",2],["template_extension=","Mustache","classes/Mustache.html#M000031","(template_extension)","",2],["template_file","Mustache","classes/Mustache.html#M000032","()","The template file is the absolute path of the file Mustache will use as its template. By default it's",2],["template_file=","Mustache","classes/Mustache.html#M000033","(template_file)","",2],["template_path","Mustache","classes/Mustache.html#M000025","()","The template path informs your Mustache subclass where to look for its corresponding template. By default",2],["template_path=","Mustache","classes/Mustache.html#M000027","(path)","",2],["templateify","Mustache","classes/Mustache.html#M000048","(obj)","",2],["templateify","Mustache","classes/Mustache.html#M000047","(obj)","Turns a string into a Mustache::Template. If passed a Template, returns it. ",2],["times","Rack::Bug::MustachePanel","classes/Rack/Bug/MustachePanel.html#M000061","()","The view render times for this page load ",2],["times","Rack::Bug::MustachePanel::View","classes/Rack/Bug/MustachePanel/View.html#M000058","()","We track the render times of all the Mustache views on this page load. ",2],["tmpid","Mustache::Template","classes/Mustache/Template.html#M000012","()","Generate a temporary id, used when compiling code. ",2],["to_html","Mustache","classes/Mustache.html#M000023","(*args)","Alias for `render` ",2],["to_html","Mustache","classes/Mustache.html#M000056","(data = template, ctx = {})","Alias for #render",2],["to_text","Mustache","classes/Mustache.html#M000024","(*args)","Alias for `render` ",2],["to_text","Mustache","classes/Mustache.html#M000057","(data = template, ctx = {})","Alias for #render",2],["underscore","Mustache","classes/Mustache.html#M000046","(classified = name)","TemplatePartial => template_partial Takes a string but defaults to using the current class' name. ",2],["utag","Mustache::Template","classes/Mustache/Template.html#M000019","(s)","{{{}}} - an unescaped tag ",2],["variables","Rack::Bug::MustachePanel","classes/Rack/Bug/MustachePanel.html#M000062","()","The variables used on this page load ",2],["variables","Rack::Bug::MustachePanel::View","classes/Rack/Bug/MustachePanel/View.html#M000059","()","Any variables used in this page load are collected and displayed. ",2],["view_class","Mustache","classes/Mustache.html#M000040","(name)","When given a symbol or string representing a class, will try to produce an appropriate view class. e.g.",2],["view_namespace","Mustache","classes/Mustache.html#M000036","()","The constant under which Mustache will look for views. By default it's `Object`, but it might be nice",2],["view_namespace=","Mustache","classes/Mustache.html#M000037","(namespace)","",2],["view_path","Mustache","classes/Mustache.html#M000038","()","Mustache searches the view path for .rb files to require when asked to find a view class. Defaults to",2],["view_path=","Mustache","classes/Mustache.html#M000039","(path)","",2],["CONTRIBUTORS","files/CONTRIBUTORS.html","files/CONTRIBUTORS.html","","* Chris Wanstrath * Francesc Esplugas * Magnus Holm * Nicolas Sanguinetti * Jan-Erik Rediger ",3],["HISTORY.md","files/HISTORY_md.html","files/HISTORY_md.html","","## 0.4.2 (2009-10-28)  * Bugfix: Ignore bad constant names when autoloading  ## 0.4.1 (2009-10-27)  *",3],["LICENSE","files/LICENSE.html","files/LICENSE.html","","Copyright (c) 2009 Chris Wanstrath  Permission is hereby granted, free of charge, to any person obtaining",3],["README.md","files/README_md.html","files/README_md.html","","Mustache =========  Inspired by [ctemplate][1] and [et][2], Mustache is a framework-agnostic way to render",3],["README.md","files/README_md.html","files/README_md.html","","Mustache =========  Inspired by [ctemplate][1] and [et][2], Mustache is a framework-agnostic way to render",3],["mustache.rb","files/lib/mustache_rb.html","files/lib/mustache_rb.html","","",3],["context.rb","files/lib/mustache/context_rb.html","files/lib/mustache/context_rb.html","","",3],["sinatra.rb","files/lib/mustache/sinatra_rb.html","files/lib/mustache/sinatra_rb.html","","",3],["template.rb","files/lib/mustache/template_rb.html","files/lib/mustache/template_rb.html","","",3],["version.rb","files/lib/mustache/version_rb.html","files/lib/mustache/version_rb.html","","",3],["mustache_panel.rb","files/lib/rack/bug/panels/mustache_panel_rb.html","files/lib/rack/bug/panels/mustache_panel_rb.html","","",3],["mustache_extension.rb","files/lib/rack/bug/panels/mustache_panel/mustache_extension_rb.html","files/lib/rack/bug/panels/mustache_panel/mustache_extension_rb.html","","",3],["view.mustache","files/lib/rack/bug/panels/mustache_panel/view_mustache.html","files/lib/rack/bug/panels/mustache_panel/view_mustache.html","","<script type=\"text/javascript\"> $(function() {   $('#mustache_variables .variable').each(function() {",3]]}}