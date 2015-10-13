require 'spec_helper'

describe "osquery missing configuration object" do
  before do
    @config = MissingConfiguration.new
  end

  subject {@config}
  it { should respond_to :id }
end
