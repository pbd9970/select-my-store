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

get '/design/home' do
  erb :home
end

get '/design/results' do
  erb :results
end

get '/design/qualities' do
  erb :qualities
end