require 'json'
require 'sinatra/activerecord'
require_relative '../../environments'

class ConfigurationGroup < ActiveRecord::Base
  # name, string
  # default_config_id, integer

  validates :name, presence: true
  has_many :configurations
  has_many :endpoints


  def default_config
    config_id = self.default_config_id || self.configurations.last
    GuaranteedConfiguration.find(config_id)
  end

  def default_config=(in_config)
    self.default_config_id = in_config.id
  end

end


class GuaranteedConfigurationGroup
  def self.find(id)
    ConfigurationGroup.find_by({id: id}) || ConfigurationGroup.find_by(name: "default")
  end

  def self.find_by(in_hash)
    logdebug "searching for a ConfigurationGroup #{in_hash.inspect}"
    ConfigurationGroup.find_by(in_hash) || ConfigurationGroup.find_by(name: "default")
  end
end
