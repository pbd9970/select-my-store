require_relative 'lib/sms.rb'

enable :sessions

get '/' do
  erb :index
end

get '/home' do
  @user = SMS::validate_user(session)   

  erb :home
end


post '/signin' do
  response = SMS::validate_user(session)
  if response[:success?]
    errors["please log out current session before logging back in"]
  else
    session[:SMS_validation] = SMS::create_session(params) 
  end

  redirect '/home'
end
