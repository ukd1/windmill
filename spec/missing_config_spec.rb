require 'rspec'
require 'rack/test'
require 'spec_helper'
require_relative '../server.rb'

describe "osquery missing configuration object" do
  before do
    @config = MissingConfiguration.new
  end

  subject {@config}
  it { should respond_to :id }
end
