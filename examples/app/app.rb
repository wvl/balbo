require 'balbo/sinatra'

class App < Sinatra::Base
  register Balbo::Sinatra
  dir = File.dirname(File.expand_path(__FILE__))
  set :views,     dir
  set :public,    "#{dir}/public"
  set :static,    true
  
  before do
    context({'site'=>{'title'=>"The Balbo"}})
  end
  
  get '/' do
    balbo :index
  end

  User = Struct.new(:name, :email, :admin)
  
  get '/profile' do
    context({'site'=>{'title'=>'Title Takeover!'}})
    balbo :profile, User.new('Joe', 'joe@example.com', false)
  end
  
  # The views module is responsible for modifying the data sent to the template if needed.
  module Views
    def profile(user)
      user.admin = true
      user
    end
  end
end


