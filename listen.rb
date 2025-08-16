require 'sinatra'
require 'json'

SECRET_TOKEN = ENV["SECRET_TOKEN"] || abort("ERROR: SECRET_TOKEN environment variable not set")

set :bind, '127.0.0.1' # Allow external connections
set :port, 8085

post '/receive' do
  request.body.rewind
  data = JSON.parse(request.body.read) rescue {}

  if data["token"] != SECRET_TOKEN
    halt 403, "Forbidden: Invalid token\n"
  end

  one = data["one"]
  two = data["two"]

  puts "Received values -> one: #{one}, two: #{two}"
  "Success: one=#{one}, two=#{two}\n"
end
