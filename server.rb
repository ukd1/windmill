require 'sinatra'
require 'json'

ENROLL_RESPONSE = {
    "node_key": "this_is_a_node_secret"
}

EXAMPLE_CONFIG = {
    "schedule": {
        "tls_proc": {"query": "select * from processes", "interval": 0},
    }
}

get '/status' do
  "running at #{Time.now}"
end

get '/api/status' do
  {"status": "running", "timestamp": Time.now}.to_json
end

post '/api/enroll' do
  if ENV['RACK_ENV'] == "development"
    puts params
  end
  ENROLL_RESPONSE.to_json
end

post '/api/config' do
  EXAMPLE_CONFIG.to_json
end

post '/' do
  puts params
end
