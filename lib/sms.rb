module SMS
  def self.db
    @__db_instance ||= DB.new
  end
end

require 'sinatra'
require 'pg'
require 'digest'
require 'securerandom'

require-relative 'sms/user.rb'
require-relative 'sms/store.rb'
require-relative 'sms/quality.rb'
require-relative 'sms/db.rb'
#require-relative "sms/scripts/*.rb"
