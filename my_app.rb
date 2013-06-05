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
  airsprint_password  = ENV['AIRSPRINT_PASSWORD'] || (settings.respond_to?(params[:service]) ? settings.send(params[:service])['webhook_password'] : 'NONE PROVIDED')
  sprintly_email      = ENV['SPRINTLY_EMAIL']     || (settings.respond_to?(:sprintly) ? settings.sprintly['email'] : 'NONE PROVIDED')
  sprintly_api_key    = ENV['SPRINTLY_API_KEY']   || (settings.respond_to?(:sprintly) ? settings.sprintly['api_key'] : 'NONE PROVIDED')
  sprintly_product_id = params[:product_id] || ENV['SPRINTLY_DEFAULT_PRODUCT_ID'] || (settings.respond_to?(:sprintly) ? settings.sprintly['product_id'] : 'NONE PROVIDED')

  if INBOUND_SERVICES.include?(params[:service]) && (airsprint_password == params[:password])
    inbound_data = JSON.parse(request.env["rack.input"].read)

    logger.warn "Service #{params[:service]}"
    logger.warn "Inbound Data: #{inbound_data.inspect}"

    sprintly = Integrations::Sprintly.new(sprintly_email, sprintly_api_key, sprintly_product_id)
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
