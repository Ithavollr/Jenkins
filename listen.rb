require 'sinatra'
require 'json'

SECRET_TOKEN = ENV["SECRET_TOKEN"] || abort("ERROR: SECRET_TOKEN environment variable not set")
## SAMPLE CURL COMMAND:
# curl -X POST http://localhost:8085/receive \
#  -H "Content-Type: application/json" \
#  -d '{"one":1,"two":2,"token":"supersecrettoken123"}'
set :bind, '127.0.0.1' # Allow external connections
set :port, 8085
set :environment, :production

# Run before each request
before do
  auth_header = request.env["HTTP_AUTHORIZATION"]
  halt 401, "Unauthorized" unless auth_header && auth_header == "Bearer #{SECRET_TOKEN}"
end

post "/pacman" do
  File.open(File.join("/servers/jenkins/cache", "Ithavollr_rpack.zip"), "wb") do |file|
    file.write(request.body.read)
  end
  status 200
  body "File received and saved successfully."
end
