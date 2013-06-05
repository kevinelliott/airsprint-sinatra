require 'sinatra'
require 'sinatra/config_file'
require 'json'
require 'faraday'
require 'faraday_middleware'
require './lib/integrations/sprintly'

INBOUND_SERVICES = %w[airbrake]

config_file 'config.yml'

get '/' do
  'Hello!'
end

post '/integrations/:service' do
  if INBOUND_SERVICES.include?(params[:service]) && (settings.send(params[:service])['webhook_password'].to_s == params[:password].to_s)
    inbound_data = JSON.parse(request.env["rack.input"].read)

    logger.warn "Service #{params[:service]}"
    logger.warn "Inbound Data: #{inbound_data.inspect}"

    sprintly = Integrations::Sprintly.new(settings.sprintly['email'], settings.sprintly['api_key'], settings.sprintly['product_id'])
    sprintly.logger = logger

    error = inbound_data['error']
    sprintly_item = {
      type: 'defect',
      title: error['error_message'],
      description: sprintly.description_from_airbrake_error(error),
      tags: params[:service]
    }
    sprintly.create_item(sprintly_item)
  end
end
