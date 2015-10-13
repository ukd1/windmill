require 'spec_helper'

describe 'GuaranteedEndpoint class methods' do
  before do
    Endpoint.create(node_key: "testingkey", assigned_config_id: 1)
  end
  subject {GuaranteedEndpoint}

  it {should respond_to(:find)}
  it {should respond_to(:find_by)}

  it "should return an Endpoint when one exists" do
    @endpoint = GuaranteedEndpoint.find_by node_key: "testingkey"
    expect(@endpoint.class.name).to eq("Endpoint")
  end

  it "should return a MissingEndpoint when one does not exist" do
    @endpoint = GuaranteedEndpoint.find_by node_key: "not_in_the_database"
    expect(@endpoint.class.name).to eq("MissingEndpoint")
  end
end
