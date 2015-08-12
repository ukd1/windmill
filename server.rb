require 'sinatra'
require 'json'

ENROLL_RESPONSE = {
    "node_key": "this_is_a_node_secret"
}

get '/status' do
  "running at #{Time.now}"
end

get '/api/status' do
  {"status": "running", "timestamp": Time.now}.to_json
end

post '/api/enroll' do
  ENROLL_RESPONSE.to_json
end

post '/api/config' do
  if ENV["RACK_ENV"] == "test"
    config_folder = "test_files"
  else
    config_folder = "osquery_configs"
  end
  File.read(File.join(config_folder, "default.conf"))
end

post '/api/config/:name' do
  if ENV["RACK_ENV"] == "test"
    config_folder = "test_files"
  else
    config_folder = "osquery_configs"
  end
  file_to_get = File.join(config_folder, "#{params['name']}.conf")
  if File.exist?(file_to_get)
    File.read(file_to_get)
  else
    File.read(File.join(config_folder, "default.conf"))
  end
end

post '/' do
  {}.to_json
end
