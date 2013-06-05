module Integrations

  class Client
    attr_accessor :base_url, :username, :password, :logger

    def initialize(options={})
      raise 'client requires :username during initialization' if options[:username].nil?
      raise 'client requires :password during initialization' if options[:password].nil?
      raise 'client requires :base_url during initialization' if options[:base_url].nil?
      @username = options[:username]
      @password = options[:password]
      @base_url = options[:base_url]
      @logger = Logger.new(STDOUT)
    end

    def client
      @conn ||= Faraday.new(url: base_url) do |faraday|
        faraday.request :url_encoded
        faraday.request :basic_auth, username, password
        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end

    def logger=(logger)
      @logger = logger
    end

    def post(path, params)
      response = client.post(path, params)
      response
    end

  end

end
