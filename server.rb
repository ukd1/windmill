require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'securerandom'
require_relative 'environments'

FAILED_ENROLL_RESPONSE = {
    "node_invalid": true
}

NODE_ENROLL_SECRET = ENV['NODE_ENROLL_SECRET'] || "valid_test"

def logdebug(message)
  if ENV['OSQUERYDEBUG']
    puts "\n" + caller_locations(1,1)[0].label + ": " + message
  end
end

class Endpoint < ActiveRecord::Base
  # node_key, string
  # last_version, string
  # config_count, integer
  # last_config_time, datetime
  # last_ip, string
  # default ruby timestamps

  def self.enroll(in_key, params)
    logdebug "received enroll_secret " + in_key

    if in_key != NODE_ENROLL_SECRET
      logdebug "invalid enroll_secret. Returning MissingEndpoint"
      MissingEndpoint.new
    else
      logdebug "valid enroll_secret. Creating new endpoint"
      params.merge! node_key: SecureRandom.uuid, config_count: 0
      Endpoint.create params
    end
  end

  def config(filename="default")
    if ENV["RACK_ENV"] == "test"
      logdebug "test environment detected. Serve files from test_files"
      config_folder = "test_files"
    else
      logdebug "serving files from osquery_configs"
      config_folder = "osquery_configs"
    end

    file_to_get = File.join(config_folder, "#{filename}.conf")

    if File.exist?(file_to_get)
      File.read(file_to_get)
    else
      logdebug "#{file_to_get} does not exist. Falling back to default."
      File.read(File.join(config_folder, "default.conf"))
    end
  end

  def node_secret
    {"node_key": node_key}.to_json
  end
end

class MissingEndpoint
  attr_accessor :node_key, :config_count, :last_version,
    :last_config_time, :last_ip

  def initialize
    @node_key = "missing endpoint"
    @last_version = "missing endpoint"
    @config_count = 0
    @last_config_time = Time.now
    @last_ip = "missing endpoint"
  end

  def valid?
    false
  end

  def config(filename="default")
    FAILED_ENROLL_RESPONSE.to_json
  end

  def save
    false
  end

  def node_secret
    logdebug "sending failed enroll response to client"
    FAILED_ENROLL_RESPONSE.to_json
  end

end

class GuaranteedEndpoint
  def self.find(id)
    begin
      Endpoint.find(id)
    rescue
      MissingEndpoint.new
    end
  end

  def self.find_by(in_hash)
    Endpoint.find_by(in_hash) || MissingEndpoint.new
  end
end

get '/status' do
  "running at #{Time.now}"
end

get '/api/status' do
  {"status": "running", "timestamp": Time.now}.to_json
end

post '/api/enroll' do
  # This next line is necessary because osqueryd does not send the
  # enroll_secret as a POST param.
  begin
    json_data = JSON.parse(request.body.read)
    params.merge!(json_data)
  rescue
  end

  @endpoint = Endpoint.enroll params['enroll_secret'],
    last_version: request.user_agent,
    last_ip: request.ip
  @endpoint.node_secret

end

post '/api/config' do
  # This next line is necessary because osqueryd does not send the
  # enroll_secret as a POST param.
  begin
    params.merge!(JSON.parse(request.body.read))
  rescue
  end
  client = GuaranteedEndpoint.find_by node_key: params['node_key']
  client.config_count += 1
  client.last_config_time = Time.now
  client.save
  client.config
end

post '/api/config/:name' do
  # This next line is necessary because osqueryd does not send the
  # enroll_secret as a POST param.
  begin
    params.merge!(JSON.parse(request.body.read))
  rescue
  end
  client = GuaranteedEndpoint.find_by node_key: params['node_key']
  client.config_count += 1
  client.last_config_time = Time.now
  client.save
  client.config params['name']
end

post '/' do
  {}.to_json
end
