#!/usr/bin/env rackup
require 'rubygems'
require 'sinatra/base'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
require File.dirname(__FILE__) + "/app"
run App.new