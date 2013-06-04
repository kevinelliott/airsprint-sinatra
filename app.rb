require 'sinatra'

get '/' do
  'Hello, Airbrake!'
end

post '/integrations/:service.?:format?' do
  "Service #{params[:service]}"
end
