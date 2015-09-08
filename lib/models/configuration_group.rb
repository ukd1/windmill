require 'json'
require 'sinatra/activerecord'
require_relative '../../environments'

class ConfigurationGroup < ActiveRecord::Base
  # name, string

  validates :name, presence: true
  has_many :configurations
  has_many :endpoints

  def default_config
    self.configurations.last.id || 0
  end

end


class GuaranteedConfigurationGroup
  def self.find_by(in_hash)
    logdebug "searching for a ConfigurationGroup #{in_hash.inspect}"
    ConfigurationGroup.find_by(in_hash) || ConfigurationGroup.find_by(name: "default")
  end
end
