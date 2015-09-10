require 'sinatra'
require 'sinatra/namespace'
require 'json'
require_relative 'lib/models/endpoint'
require_relative 'lib/models/configuration'
require_relative 'lib/models/configuration_group'
require_relative 'lib/models/enroller'

NODE_ENROLL_SECRET = ENV['NODE_ENROLL_SECRET'] || "valid_test"

def logdebug(message)
  if ENV['OSQUERYDEBUG']
    puts "\n" + caller_locations(1,1)[0].label + ": " + message
  end
end

get '/status' do
  "running at #{Time.now}"
end

get '/' do
  redirect '/configuration-groups'
end

namespace '/api' do
  get '/status' do
    {"status": "running", "timestamp": Time.now}.to_json
  end

  post '/enroll' do
    # This next line is necessary because osqueryd does not send the
    # enroll_secret as a POST param.
    begin
      json_data = JSON.parse(request.body.read)
      params.merge!(json_data)
    rescue
    end

    @endpoint = Enroller.enroll params['enroll_secret'],
      last_version: request.user_agent,
      last_ip: request.ip
    @endpoint.node_secret
  end

  post '/config' do
    # This next line is necessary because osqueryd does not send the
    # enroll_secret as a POST param.
    begin
      params.merge!(JSON.parse(request.body.read))
    rescue
    end
    client = GuaranteedEndpoint.find_by node_key: params['node_key']
    logdebug "Received endpoint: #{client.inspect}"
    client.get_config
  end

end

namespace '/configuration-groups' do
  get  do
    @groups = ConfigurationGroup.all
    erb :"configuration_groups/index"
  end

  post do
    @cg = ConfigurationGroup.create(name: params[:name])
    redirect '/configuration-groups'
  end

  namespace '/:cg_id' do
    get do
      @cg = ConfigurationGroup.find(params[:cg_id])
      erb :"configuration_groups/show"
    end

    post do
      @cg = ConfigurationGroup.find(params[:cg_id])
      puts "we're good"
      @config = @cg.configurations.build(params[:config])
      puts @config.inspect
      if @config.save
        redirect "/configuration-groups/#{@cg.id}"
      else
        @config.errors.messages.to_s
      end
    end

    namespace '/configurations/new' do
      get do
        @cg = ConfigurationGroup.find(params[:cg_id])
        @config = @cg.configurations.build
        erb :"configurations/new"
      end
    end
  end
end
