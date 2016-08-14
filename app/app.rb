ENV['RACK_ENV'] ||= 'development'

require 'sinatra/base'
require 'sinatra/flash'

require_relative 'data_mapper_setup.rb'
require_relative 'models/user.rb'
require_relative 'models/peep.rb'

class Chitter < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash

  get '/' do
    redirect '/user/index'
  end

  get '/user/index' do
    @peeps = Peep.all
    erb :'user/index'
  end

  get '/user/new' do
    erb :'user/new'
  end

  post '/user' do
      user = User.create(first_name: params[:first_name],
      second_name: params[:second_name],
      username: params[:username],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation])
      session[:user_id] = user.id
      redirect '/user/index'
  end


  delete '/sessions' do
    session[:user_id] = nil
    redirect '/user/index'
  end

  post '/sessions' do
    user = User.authenticate(params[:email], params[:password])
    if user
     session[:user_id] = user.id
     redirect '/user/index'
    else
      flash.now[:errors] = ["Incorrect password entered. Please retry."]
      erb :'user/index'
    end
  end


  get '/peeps/new' do
    erb :'peeps/new'

  end

  post '/peeps/index'do
    user = User.first(id: session[:user_id])
      if user
      peep = Peep.new(content: params[:content])
      peep.user = user
      user.save
      peep.save
      redirect '/user/index'
      else
      end
  end

  helpers do
      def current_user
        @current_user ||= User.get(session[:user_id])
      end
  end

run! if app_file == $0
end
