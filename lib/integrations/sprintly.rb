require './lib/integrations/client'

module Integrations

  class Sprintly
    attr_accessor :logger

    def initialize(email, api_key, product_id, options={})
      @email      = email
      @api_key    = api_key
      @product_id = product_id
      @base_url   = options[:base_url] || 'https://sprint.ly/api'
      @logger     = Logger.new(STDOUT)

      client_options = { base_url: @base_url, username: @email, password: @api_key }
      puts client_options.inspect
      @client   = Integrations::Client.new(client_options)
    end

    def logger=(logger)
      @logger = @client.logger = logger
    end

    def create_item(item={})
      items_path = "products/#{@product_id}/items.json"

      logger.warn "Sprintly Base URL    : #{@client.base_url}"
      logger.warn "Sprintly Items Path  : #{items_path}"
      logger.warn "Sprintly Items Params: #{item.inspect}"

      response = @client.post(items_path, item)

      if response.status == 400
        logger.warn "Error from Sprintly: #{response.body['message']}"
      end

      response.body.to_json
    end

    def description_from_airbrake_error(error)
      last_notice = error['last_notice']
      backtrace   = last_notice['backtrace'].join('  ')
      description = <<EOD

# Exception for #{error['project']['name']}

An exception was triggered in the application via Airbrake.

## Request

Request Method: #{last_notice['request_method'] || 'Unknown'}
Request URL: #{last_notice['request_url']}

## Details

Environment: #{last_notice['environment'] || 'Unknown'}
First Occurred: #{last_notice['first_occurred_at'] || 'Unknown'}
Last Occured: #{last_notice['last_occurred_at'] || 'Unknown'}
Times Occured: #{last_notice['times_occurred'] || 'Unknown'}

## Backtrace

> #{backtrace}

EOD
      description
    end
    
  end

end
  