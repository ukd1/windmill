require 'sinatra'
require 'json'
require_relative 'lib/models/endpoint'

FAILED_ENROLL_RESPONSE = {
    "node_invalid": true
}

NODE_ENROLL_SECRET = ENV['NODE_ENROLL_SECRET'] || "valid_test"

def logdebug(message)
  if ENV['OSQUERYDEBUG']
    puts "\n" + caller_locations(1,1)[0].label + ": " + message
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
