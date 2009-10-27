require 'balbo/sinatra'

class App < Sinatra::Base
  dir = File.dirname(File.expand_path(__FILE__))
  set :views,     dir
  set :public,    "#{dir}/public"
  set :static,    true
  
  User = Struct.new(:name, :email)
  
  Balbo.lookup({'site'=>{'title'=>"The Balbo"}})
  
  get '/' do
    balbo :index
  end
  
  get '/profile' do
    balbo :profile, User.new('Joe', 'joe@example.com')
  end
end


