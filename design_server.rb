require 'sinatra'
require 'sinatra/json'
require 'pry'

require_relative 'lib/sms.rb'

set :bind, '0.0.0.0'
set :port, 9494

get '/design/home' do
  @message = "im data"
  erb :index
end

