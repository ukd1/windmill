require 'rspec'
require 'rack/test'
require 'spec_helper'
require_relative '../server.rb'

describe 'Endpoint instance methods' do
  before do
    @config = Configuration.create(name:"test", version:1, notes:"test", config_json: {test:"test"}.to_json)
    @endpoint = Endpoint.create(node_key:"test", configuration_id: @config.id)
  end

  subject { @endpoint }
  it {should respond_to(:node_key)}
  it {should respond_to(:last_version)}
  it {should respond_to(:config_count)}
  it {should respond_to(:last_ip)}
  it {should respond_to(:created_at)}
  it {should respond_to(:updated_at)}
  it {should respond_to(:last_config_time)}
  it {should respond_to(:config)}
  it {should respond_to(:node_secret)}
  it {should respond_to(:identifier)}
  it {should respond_to(:group_label)}
  it {should respond_to(:configuration_id)}

  it "should return a configuration" do
    expect(@endpoint.configuration.id).to eq(@config.id)
  end

  it "should require a node_key" do
    expect(@endpoint.valid?).to be_truthy
    @endpoint.node_key = nil
    expect(@endpoint.valid?).to be_falsey
  end

  it "should require a configuration id" do
    expect(@endpoint.valid?).to be_truthy
    @endpoint.configuration_id = nil
    expect(@endpoint.valid?).to be_falsey
  end
end

describe 'Endpoint class methods' do
  subject {Endpoint}
  it {should respond_to(:enroll)}
end
