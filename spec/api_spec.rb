require_relative '../server.rb'  # <-- your sinatra app
require 'rspec'
require 'rack/test'
require 'spec_helper'

describe 'The osquery TLS api' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  valid_node_key = ""

  it "returns a status" do
    get '/api/status'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json["status"]).to eq("running")
    expect(json).to have_key("timestamp")
  end

  it "enrolls a node with a valid enroll secret" do
    pre_enroll_endpoint_count = Endpoint.count
    post '/api/enroll', {enroll_secret: "valid_test"}
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json).to have_key("node_key")
    valid_node_key = json["node_key"]
    expect(Endpoint.count).to eq(pre_enroll_endpoint_count + 1)
  end

  it "rejects a node with an invalid enroll secret" do
    post '/api/enroll', enroll_secret: "invalid_test"
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json).to have_key("node_invalid")
    expect(json["node_invalid"]).to eq(true)
  end

  it "returns a default configuration with a valid node secret" do
    post '/api/config', node_key: valid_node_key
    expect(last_response).to be_ok
    expect(last_response.body).to match(/This is the default test file/)
  end

  it "returns a named configuration with a valid node secret" do
    post '/api/config/web', node_key: valid_node_key
    expect(last_response).to be_ok
    expect(last_response.body).to match(/This is the web test file/)
  end

  it "returns the default config when a named config cannot be found with a valid node secret" do
    post '/api/config/unknown', node_key: valid_node_key
    expect(last_response).to be_ok
    expect(last_response.body).to match(/This is the default test file/)
  end

  it "rejects a request for configuration from a node with an invalid node secret" do
    ['/api/config', '/api/config/web', '/api/config/unknown'].each do |path|
      post path, node_key: "invalid_test"
      expect(last_response).to be_ok
      json = JSON.parse(last_response.body)
      expect(json).to have_key("node_invalid")
      expect(json["node_invalid"]).to eq(true)
    end
  end
end
