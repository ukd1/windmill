require_relative '../server.rb'  # <-- your sinatra app
require 'rspec'
require 'rack/test'
require 'spec_helper'

describe 'The osquery TLS api' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "returns a status" do
    get '/api/status'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json["status"]).to eq("running")
    expect(json["timestamp"]).to match(/^\d{4}-\d{2}-\d{2}\ (\d{2}:){2}\d{2}\ [+-]\d{4}$/)
  end

  it "enrolls a node" do
    post '/api/enroll'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json).to have_key("node_key")
  end

  it "returns a default configuration" do
    post '/api/config'
    expect(last_response).to be_ok
    expect(last_response.body).to match(/This is the default test file/)
  end

  it "returns a named configuration" do
    post '/api/config/web'
    expect(last_response).to be_ok
    expect(last_response.body).to match(/This is the web test file/)
  end

  it "returns the default config when a named config cannot be found" do
    post '/api/config/unknown'
    expect(last_response).to be_ok
    expect(last_response.body).to match(/This is the default test file/)
  end
end
