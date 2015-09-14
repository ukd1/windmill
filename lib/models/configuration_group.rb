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

  def assign_config_percent(config, in_percent)
    begin
      if in_percent.to_i > 100
        return false
      end
      if in_percent.to_i <= 0
        return false
      end
    rescue
      return false
    end
    if !self.configurations.include?(config)
      return false
    end

    # Here are the endpoints that already have the config being assigned
    already_done = self.endpoints.where(assigned_config: config)

    # Shuffle the rest of the endpoints
    remaining = self.endpoints.except(assigned_config: config).shuffle

    # merge the two collections
    all_endpoints = already_done + remaining

    # now get the front of the whole list and assign configurations
    all_endpoints[0..(all_endpoints.count * (in_percent/100.0)).to_i].each do |e|
      e.assigned_config = config
      e.save
    end
    true
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
