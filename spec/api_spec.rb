require_relative '../server.rb'  # <-- your sinatra app
require 'rspec'
require 'rack/test'

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

  it "returns a configuration" do
    post '/api/config'
    expect(last_response).to be_ok
    json = JSON.parse(last_response.body)
    expect(json).to have_key("schedule")
  end
end
