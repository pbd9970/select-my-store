module SMS
  def db
    @__db_instance ||= DB.new
  end

require 'sinatra'
require 'pg'
require 'digest'
require 'securerandom'

require-relative 'lib/user.rb'
require-relative 'lib/store.rb'
require-relative 'lib/quality.rb'
require-relative 'lib/db.rb'
require-relative "lib/scripts/*.rb"
