#!/usr/bin/env rackup
require 'rubygems'
require 'sinatra/base'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
require 'rack/bug'
#require 'rack/bug/panels/mustache_panel'
require File.dirname(__FILE__) + "/app"
use Rack::Bug
#::MustachePanel

run App.new