class SMS::Session
  @@return_hash = {errors: [], success?: false}.freeze
  def self.validate(session)

    return_hash = @@return_hash.dup
    cols_hash = Hash.new

    cols_hash[:session_id]  = session[:sms_session_id]
    cols_hash[:session_key] = session[:sms_session_key]

    result = SMS.db.select_join(SMS::User, :user_id, cols_hash, [:users, :sessions]).first

    if result
      return_hash[:success?] = true
      return_hash[:user    ] = result
    else
      return_hash[:error   ] = "Invalid session"
    end
    return_hash
  end

  def self.delete(session)

    return_hash = @@return_hash.dup
    cols_hash = Hash.new

    cols_hash = Hash.new
    session_id  = session[:sms_session_id]

    result = SMS.db.delete(:sessions, session_id, :session_id)
    if result
      return_hash[:success?] = true
    else
      return_hash[:errors]   = "Error during logout"
    end
    return_hash
  end

  def self.create(params)

    return_hash = @@return_hash.dup

    user = SMS::User.new(params).retrieve!

    if user
      if user.has_password? params[:password]
        session_key = SecureRandom.base64

        session_id = SMS.db.insert_into(:sessions, {session_key: session_key, user_id: user.user_id}, :session_id)

        if session_id
          return_hash[:sms_session_key] = session_key
          return_hash[:sms_session_id ] = session_id 
          return_hash[:success?       ] = true
        else
          return_hash[:errors         ] = "There was a problem signing in"
        end
      else
        return_hash[:errors] = "Invalid password"
      end
    else
      return_hash[:errors] = "Invalid username"
    end
    return_hash
  end
end
