require 'sinatra'
require 'json'

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

get '/status' do
  "running at #{Time.now}"
end

get '/api/status' do
  {"status": "running", "timestamp": Time.now}.to_json
end

post '/api/enroll' do
  enroll_key = ENV['NODE_ENROLL_SECRET'] || "valid_test"
  if params['enroll_secret'] == enroll_key
    ENROLL_RESPONSE.to_json
  else
    FAILED_ENROLL_RESPONSE.to_json
  end
end

post '/api/config' do
  config_getter
end

post '/api/config/:name' do
  config_getter(params['name'])
end

post '/' do
  {}.to_json
end
