module SMS
  def self.db
    @__db_instance ||= SMS::DB.new
  end
end

require 'sinatra'
require 'pg'
require 'digest'
require 'securerandom'
require 'ostruct'

require_relative 'sms/user.rb'
require_relative 'sms/store.rb'
require_relative 'sms/quality.rb'
require_relative 'sms/db.rb'
#require-relative "sms/scripts/*.rb"
