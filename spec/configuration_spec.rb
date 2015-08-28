require 'rspec'
require 'rack/test'
require 'spec_helper'
require_relative '../server.rb'

describe "osquery configuration files" do
  before do
    @config = Configuration.new(name:"test", version:1, notes:"test", config_json: {test:"test"}.to_json)
  end

  subject {@config}
  it { should respond_to :id }
  it { should respond_to :name }
  it { should respond_to :version }
  it { should respond_to :config_json }
  it { should respond_to :notes }

  it "should require a name" do
    expect(@config.valid?).to be_truthy
    @config.name = nil
    expect(@config.valid?).to be_falsey
  end

  it "should require a version" do
    expect(@config.valid?).to be_truthy
    @config.version = nil
    expect(@config.valid?).to be_falsey
  end

  it "should require a config_json" do
    expect(@config.valid?).to be_truthy
    @config.config_json = nil
    expect(@config.valid?).to be_falsey
  end

  it "should require valid json in config_json" do
    expect(@config.valid?).to be_truthy
    @config.config_json = "not valid json"
    expect(@config.valid?).to be_falsey
  end

end
