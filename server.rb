require 'sinatra'
require 'json'
require 'securerandom'

ENROLL_RESPONSE = {
    "node_key": "this_is_a_node_secret"
}

FAILED_ENROLL_RESPONSE = {
    "node_invalid": true
}

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
  keys = File.readlines("node_keys.txt").map {|x| x.strip}
  if keys.include?(in_key)
    true
  else
    false
  end
end

def valid_enroll_key?(inKey)
  enroll_key = ENV['NODE_ENROLL_SECRET'] || "valid_test"
  if inKey == enroll_key
    true
  else
    false
  end
end

def enroll_endpoint
  node_secret = SecureRandom.uuid
  savefile = open("node_keys.txt", "wb")
  savefile.puts(node_secret)
  savefile.close
  {"node_key": node_secret}.to_json
end

get '/status' do
  "running at #{Time.now}"
end

get '/api/status' do
  {"status": "running", "timestamp": Time.now}.to_json
end

post '/api/enroll' do
  if valid_enroll_key?(params['enroll_secret'])
    enroll_endpoint
  else
    FAILED_ENROLL_RESPONSE.to_json
  end
end

post '/api/config' do
  if valid_node_key?(params["node_key"])
    config_getter
  else
    FAILED_ENROLL_RESPONSE.to_json
  end
end

post '/api/config/:name' do
  if valid_node_key?(params["node_key"])
    config_getter(params['name'])
  else
    FAILED_ENROLL_RESPONSE.to_json
  end
end

post '/' do
  {}.to_json
end
