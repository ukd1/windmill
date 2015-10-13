require 'spec_helper'

describe "osquery configuration groups" do
  before do
    @cg = ConfigurationGroup.create(name: "test")
    @cg2 = ConfigurationGroup.new(name: "test2")
    @config = @cg.configurations.create(name: "test_config", version: 1, config_json: {test: "test"}.to_json)
    @config2 = @cg.configurations.create(name: "test_config2", version:1, config_json: {test: "test2"}.to_json)
    @endpoint = @cg.endpoints.create(node_key:"test")
  end

  subject {@cg}
  it { should respond_to :id }
  it { should respond_to :name }
  it { should respond_to :configurations }
  it { should respond_to :endpoints }
  it { should respond_to :default_config }
  it { should respond_to :default_config= }

  it "should require a name" do
    expect(@cg2.valid?).to be_truthy
    @cg2.name = nil
    expect(@cg2.valid?).to be_falsey
  end

  it "should return a collection of endpoints" do
    expect(@cg.endpoints.count).to be > 0
  end

  it "should return a collection of configurations" do
    @configs = @cg.configurations.all
    expect(@configs.length).to be > 0
  end

  it "should return the last configuration if no default_config is set" do
    expect(@cg.default_config).to eq(@config2)
  end

  it "should allow you to set a different default_config" do
    @cg.default_config = @config
    expect(@cg.default_config).to eq(@config)
  end

end
