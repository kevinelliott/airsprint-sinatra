require 'sinatra'

class MyApp < Sinatra::Application
  get '/' do
    'Hello, Airbrake!'
  end

  post '/integrations/:service.?:format?' do
    "Service #{params[:service]}"
    logger.warn params.inspect
  end
end
