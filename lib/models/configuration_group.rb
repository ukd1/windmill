require 'json'
require 'sinatra/activerecord'
require_relative '../../environments'

class ConfigurationGroup < ActiveRecord::Base
  # name, string

  validates :name, presence: true
  has_many :configurations
  has_many :endpoints

end
