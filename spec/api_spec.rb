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
  end
end
