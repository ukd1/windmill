require 'rspec'
require 'rack/test'
require 'spec_helper'
require_relative '../server.rb'

describe "osquery configuration files" do
  before do
    @config = Configuration.new
  end

  subject {@config}
  it { should respond_to :id }
  it { should respond_to :name }
  it { should respond_to :version }
  it { should respond_to :config_json }
  it { should respond_to :notes }
end
