require 'rspec'
require 'rack/test'
require 'spec_helper'
require_relative '../server.rb'

describe 'MissingEndpoint instance methods' do
  before do
    @missing_endpoint = MissingEndpoint.new
  end

  subject { @missing_endpoint }
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
end
