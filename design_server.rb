require 'sinatra'
require 'sinatra/json'
require 'pry'
require_relative 'lib/sms.rb'

# require_relative 'lib/sms.rb'
enable 'sessions'

set :bind, '0.0.0.0'
set :port, 9494

get '/' do
  erb :index
end

get '/design' do
  @message = "im data"
  erb :index
end


get '/design/home' do
  @user = true
  erb :home
end

post '/design/home' do
  @user = SMS::Session.validate(session)

  erb :home
end


post 'design/logout' do
  results = SMS::Session.validate(session)
  if results[:success?]
    @user = results[:user]
    @error = results[:error]
  end

  erb :sign_out
end

post '/design/sign_up' do
  @user = SMS::User.new(params)
  @user.save!

  SMS::Session.create(params)
  redirect '/design/home'

end

get '/design/results' do
  erb :results
end

get '/design/qualities' do
  # data call here to actually get them
  @qualities = ["sassy", "chic", "couture", "hip", "grunge","sassy", "chic", "couture", "hip", "grunge","sassy", "chic", "couture", "hip", "grunge"]
  @female = true
  erb :qualities
end

get '/api/qualities' do
  @qualities = ["sassy", "chic", "couture", "hip", "grunge","sassy", "chic", "couture", "hip", "grunge","sassy", "chic", "couture", "hip", "grunge"]
  json @qualities
end











