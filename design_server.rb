require 'sinatra'
require 'sinatra/json'
require 'pry'
require_relative 'lib/sms.rb'

# require_relative 'lib/sms.rb'
enable :sessions

set :bind, '0.0.0.0'
set :port, 9494

get '/' do
  result = SMS::Session.validate(session)

  if result[:success?]
    @user = result[:user]
    redirect to '/home'
  else
    erb :index
  end
end

get '/home' do
  result = SMS::Session.validate(session)
  @errors = result[:errors]

  if result[:success?]
    @user = result[:user]
    erb :home
  else
    erb :index
  end
end


post '/sign_out' do
  result = SMS::Session.validate(session)
  @error = result[:error]

  SMS::Session.delete(session)
  session.clear

  erb :index
end

post '/sign_in' do
  result = SMS::Session.create(params)
  @errors = result[:errors]

  if result[:success?]
    session[:sms_session_key] = result[:sms_session_key]
    session[:sms_session_id ] = result[:sms_session_id ]

    redirect to '/home'
  else
    erb :index
  end
end

post '/sign_up' do
  @user = SMS::User.new(params)
  @user.save!

  result = SMS::Session.create(params)
  @errors = result[:errors]

  if result[:success?]
    session[:sms_session_key] = result[:sms_session_key]
    session[:sms_session_id ] = result[:sms_session_id ]

    redirect to '/home'
  else
    erb :index
  end
end

get '/results' do
  erb :results
end

post '/qualities' do
  # data call here to actually get them
  @qualities = ["sassy", "chic", "couture", "hip", "grunge","sassy", "chic", "couture", "hip", "grunge","sassy", "chic", "couture", "hip", "grunge"]
  @female = true
  erb :qualities
end

get '/api/qualities' do
  @qualities = ["sassy", "chic", "couture", "hip", "grunge","sassy", "chic", "couture", "hip", "grunge","sassy", "chic", "couture", "hip", "grunge"]
  json @qualities
end
