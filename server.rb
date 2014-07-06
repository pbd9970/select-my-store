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


get '/sign_out' do
  result = SMS::Session.validate(session)
  @error = result[:error]

  SMS::Session.delete(session)
  session.clear

  erb :index
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
  result = SMS::Session.validate(session)
  @errors = result[:errors]

  if result[:success?]
    @user = result[:user]

    #params expected to look like: {"sex" => "female", "age" =>  30}
    #We can't use the age variable until after the user selects their qualities,
    #so we store the age and sex temporarily in browser cookie

    if params["age"] >= 18 || params["age"] <= 55
      session[:age] = params["age"]
      session[:sex] = params["sex"]

      @qualities = SMS::Quality.available({sex: params["sex"]})  #=> array of quality objects
      @qualities.map! { |quality| quality.name }
    else
      @errors.push("Sorry, that age is not supported at this time")
      @qualities = [] # You might add a go back button that would redirect to home, maybe?
      #@qualities = ["Go Back"]
    end

    erb :qualities

  else
    erb :index
  end
end

post '/stores' do
  result = SMS::Session.validate(session)
  @errors = result[:errors]

  if result[:success?]
    @user = result[:user]

    #Caresa - whatever data structure you decided on is fine, just paste your
    #code here and set it equal to variable quality_array
 
    quality_array = params[:quality_hash].select { |quality, value| value == true }.keys
    
    @stores = @user.stores(quality_array, session["sex"], session["age"])
    if @stores
    else
      @errors.push("Sorry, no results match your search")
    end

    erb :results
    #@stores.name, @stores.website, @stores.image_url, @stores.detail are all available
  else
    erb :index
  end
end

get '/api/qualities' do
  @qualities = ["sassy", "chic", "couture", "hip", "grunge","sassy", "chic", "couture", "hip", "grunge","sassy", "chic", "couture", "hip", "grunge"]
  json @qualities
end
