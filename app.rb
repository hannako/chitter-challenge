ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
require 'sinatra/flash'

require_relative './app/data_mapper_setup.rb'
require './app/models/user.rb'

class Chitter < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash

  get '/' do
    erb :'index'
    #index.erb = enter chitter button
  end

  get '/user/index' do
    erb :'user/index'
    #user/index.erb = sign me up or sign in
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
      # session[:first_name] = params[:first_name]
      redirect '/peeps/index'
  end

  get '/peeps/index' do
    erb :'peeps/index'
    #peeps/index is the links homepage
  end

  post '/sessions' do
    user = User.authenticate(params[:email], params[:password])
    if user
     redirect '/peeps/index'
     session[:user_id] = user.id
    else
      flash.now[:errors] = ["Incorrect password entered. Please retry."]
      erb :'user/new'
    end
  end

  helpers do
      def current_user
        @current_user ||= User.get(session[:user_id])
      end
  end

run! if app_file == $0
end
