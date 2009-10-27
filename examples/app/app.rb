require 'balbo/sinatra'

class App < Sinatra::Base
  dir = File.dirname(File.expand_path(__FILE__))
  set :views,     dir
  set :public,    "#{dir}/public"
  set :static,    true
  
  get '/' do
    balbo :index, {'title'=>"The Balbo"}
  end
end


