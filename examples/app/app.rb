require 'balbo/sinatra'

class ViewHelpers
  def initialize(user=nil)
    @user = user
  end
  
  def logged_in?
    !!@user
  end
end

class App < Sinatra::Base
  register Balbo::Sinatra
  dir = File.dirname(File.expand_path(__FILE__))
  set :views,     dir
  set :public,    "#{dir}/public"
  set :static,    true
  
  User = Struct.new(:name, :email, :admin)

  before do
    @user = User.new('Joe', 'joe@example.com', false)
    context ViewHelpers.new(@user)
    context({'site'=>{'title'=>"The Balbo"}})
  end
  
  get '/' do
    balbo :index
  end
  
  get '/profile' do
    context({'site'=>{'title'=>'Title Takeover!'}})
    balbo :profile, @user
  end
  
  # The views module is responsible for modifying the data sent 
  # to the template if needed.
  module Views
    def profile(user)
      user.admin = true
      user
    end
  end
end


