require 'rspec'
require 'rack/test'
require 'spec_helper'
require_relative '../server.rb'

describe "osquery configuration groups" do
  before do
    @cg = ConfigurationGroup.new(name: "test")
  end

  subject {@cg}
  it { should respond_to :id }
  it { should respond_to :name }
end
