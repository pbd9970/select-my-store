require 'sinatra'
require 'sinatra/json'
require 'pry'

require_relative 'lib/sms.rb'

set :bind, '0.0.0.0'
set :port, 9494

get '/design' do
  @message = "im data"
  erb :index
end

post '/design/sign_in' do
  puts params
  erb :index
end

post '/sign_in' do
  params
  result = SMS.script.sign_in(params)
  if result[:success?]
    user = result[:user]
    @username = user.username
    @user_id = user.id
    session[:username] = user.username
    redirect '/design'
  else
    @error = result[:error]
    erb :signin_error
  end

get '/design/home' do
  erb :home
end

get '/design/results' do
  erb :results
end

get '/design/qualities' do
  erb :qualities
end

end
