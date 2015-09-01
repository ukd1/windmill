require 'json'
require 'sinatra/activerecord'
require_relative '../../environments'

class Configuration < ActiveRecord::Base
  # name, string
  # version, integer
  # config_json, text
  # notes, text

  validates :name, :version, :config_json, presence: true
  validate :json_validator

  has_many :endpoints
  belongs_to :configuration_group

  def json_validator
    begin
      JSON.parse!(self.config_json)
    rescue
      errors.add(:config_json, "Not parsable JSON")
    end
    true
  end
end
