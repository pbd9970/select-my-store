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

# get '/design/home' do
# <<<<<<< HEAD
#   erb :index
# end

# <<<<<<< HEAD
# post '/sign_in' do
#   if user
#     redirect '/design/home'
#   end

# =======
# post '/design/home' do
# >>>>>>> c1d31e7449ef65a4cee4922aa66b1af258a274d6
#   puts params
#   erb :index
# end

# post '/sign_in' do
#   params
# <<<<<<< HEAD
#   @user = true
#   # result = SMS.script.sign_in(params)
#   # if result[:success?]
#   #   user = result[:user]
#   #   @username = user.username
#   #   @user_id = user.id
#   #   session[:username] = user.username
#   #   redirect '/design'
#   # else
#   #   @error = result[:error]
#   #   erb :signin_error
#   # end
# =======
#   result = SMS.script.sign_in(params)
#   if result[:success?]
#     user = result[:user]
#     @username = user.username
#     @user_id = user.id
#     session[:username] = user.username
#     redirect '/design'
#   else
#     @error = result[:error]
#     erb :signin_error
#   end
#   redirect to '/design/home'
# >>>>>>> c1d31e7449ef65a4cee4922aa66b1af258a274d6
# end

get '/design/home' do
  @user = true
  erb :home
end

post '/design/home' do
  @user = SMS::Session.validate(session)

  erb :home
end

# post '/sign_in' do
#   params
#   result = SMS.script.sign_in(params)
#   if result[:success?]
#     user = result[:user]
#     @username = user.username
#     @user_id = user.id
#     session[:username] = user.username
#     redirect '/design'
#   else
#     @error = result[:error]
#     erb :signin_error
#   end

# get '/design/home' do
#   erb :home
# end

post '/design/sign_up' do
  @user = SMS::User.new(params)
  @user.save!

  SMS::Session.create(params)
  reroute '/design/home'

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











