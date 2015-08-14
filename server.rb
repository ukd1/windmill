require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'securerandom'
require_relative 'environments'

ENROLL_RESPONSE = {
    "node_key": "this_is_a_node_secret"
}

FAILED_ENROLL_RESPONSE = {
    "node_invalid": true
}

class Endpoint < ActiveRecord::Base
  # node_key, string
  # last_version, string
  # config_count, integer
  # last_ip, string
  # default ruby timestamps
end

def config_getter(filename="default")
  if ENV["RACK_ENV"] == "test"
    config_folder = "test_files"
  else
    config_folder = "osquery_configs"
  end

  file_to_get = File.join(config_folder, "#{filename}.conf")

  if File.exist?(file_to_get)
    File.read(file_to_get)
  else
    File.read(File.join(config_folder, "default.conf"))
  end
end

def valid_node_key?(in_key)
  @endpoint = Endpoint.find_by node_key: in_key

  if @endpoint.nil?
    false
  else
    true
  end
end

def valid_enroll_key?(in_key)
  enroll_key = ENV['NODE_ENROLL_SECRET'] || "valid_test"
  if in_key == enroll_key
    puts "valid_enroll_key? - valid key detected" if ENV['OSQUERYDEBUG']
    true
  else
    puts "valid_enroll_key? - key does not match #{ENV['NODE_ENROLL_SECRET']}" if ENV['OSQUERYDEBUG']
    false
  end
end

def enroll_endpoint(in_agent="none", in_ip="none")
  node_secret = SecureRandom.uuid
  @endpoint = Endpoint.new node_key: node_secret, last_version: in_agent, last_ip: in_ip
  if @endpoint.save
    {"node_key": node_secret}.to_json
  else
    {"error":"error enrolling endpoint"}
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

  puts "POST:api/enroll - received enroll_secret #{params['enroll_secret']}" if ENV['OSQUERYDEBUG']

  if valid_enroll_key?(params['enroll_secret'])
    enroll_endpoint(request.user_agent, request.ip)
  else
    FAILED_ENROLL_RESPONSE.to_json
  end
end

post '/api/config' do
  # This next line is necessary because osqueryd does not send the
  # enroll_secret as a POST param.
  begin
    params.merge!(JSON.parse(request.body.read))
  rescue
  end
  if valid_node_key?(params["node_key"])
    config_getter
  else
    FAILED_ENROLL_RESPONSE.to_json
  end
end

post '/api/config/:name' do
  # This next line is necessary because osqueryd does not send the
  # enroll_secret as a POST param.
  begin
    params.merge!(JSON.parse(request.body.read))
  rescue
  end
  if valid_node_key?(params["node_key"])
    config_getter(params['name'])
  else
    FAILED_ENROLL_RESPONSE.to_json
  end
end

post '/' do
  {}.to_json
end
