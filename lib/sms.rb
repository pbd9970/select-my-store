module SMS
  def db
    @__db_instance ||= DB.new
  end

module SMS
  def db
    @__db_instance ||= DB.new
  end

require 'sinatra'
require 'pg'
require 'digest'
require 'securerandom'

require 'sinatra'
require 'pg'
require 'digest'
require 'securerandom'


require-relative 'lib/user.rb'
require-relative 'lib/store.rb'
require-relative 'lib/quality.rb'
require-relative 'lib/db.rb'
require-relative "lib/scripts/*.rb"
=======
  def self.db
    @__db_instance ||= SMS::DB.new
  end
end


require 'sinatra'
require 'pg'
require 'digest'
require 'securerandom'

require_relative 'sms/user.rb'
require_relative 'sms/store.rb'
require_relative 'sms/quality.rb'
require_relative 'sms/db.rb'
require-relative "sms/scripts/*.rb"
