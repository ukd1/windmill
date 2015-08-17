require 'rspec'
require 'rack/test'
require 'spec_helper'
require_relative '../server.rb'

describe 'Endpoint instance methods' do
  before do
    @new_endpoint = Endpoint.new
  end

  subject { @new_endpoint }
  it {should respond_to(:node_key)}
  it {should respond_to(:last_version)}
  it {should respond_to(:config_count)}
  it {should respond_to(:last_ip)}
  it {should respond_to(:created_at)}
  it {should respond_to(:updated_at)}
  it {should respond_to(:last_config_time)}
  it {should respond_to(:config)}
  it {should respond_to(:node_secret)}
end

describe 'Endpoint class methods' do
  subject {Endpoint}
  it {should respond_to(:enroll)}
end
