require 'rspec'
require 'rack/test'
require 'spec_helper'
require_relative '../server.rb'

describe "osquery configuration groups" do
  before do
    @cg = ConfigurationGroup.create(name: "test")
    @cg2 = ConfigurationGroup.new(name: "test2")
    @config = @cg.configurations.create(name: "test_config", version: 1, config_json: {test: "test"}.to_json)
    @endpoint = @cg.endpoints.create(node_key:"test", assigned_config_id: @config.id)
  end

  subject {@cg}
  it { should respond_to :id }
  it { should respond_to :name }
  it { should respond_to :configurations }
  it { should respond_to :endpoints }

  it "should require a name" do
    expect(@cg2.valid?).to be_truthy
    @cg2.name = nil
    expect(@cg2.valid?).to be_falsey
  end

  it "should return a collection of endpoints" do
    @return_points = @cg.endpoints.all
    expect(@return_points.length).to be > 0
  end

  it "should return a collection of configurations" do
    @configs = @cg.configurations.all
    expect(@configs.length).to be > 0
  end
end
