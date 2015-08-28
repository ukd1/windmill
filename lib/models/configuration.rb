require 'sinatra/activerecord'
require_relative '../../environments'

class Configuration < ActiveRecord::Base
  # name, string
  # version, integer
  # config_json, text
  # notes, text
end
