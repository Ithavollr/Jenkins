require 'sinatra'
require 'json'

SECRET_TOKEN = ENV["SECRET_TOKEN"] || abort("ERROR: SECRET_TOKEN environment variable not set")
## SAMPLE CURL COMMAND:
# curl -X POST http://localhost:8085/receive \
#  -H "Content-Type: application/json" \
#  -d '{"one":1,"two":2,"token":"supersecrettoken123"}'
set :bind, '127.0.0.1' # Allow external connections
set :port, 8085

# Run before each request
before do
  if request.request_method == "POST"
    request.body.rewind
    @data = JSON.parse(request.body.read) rescue {}
    if @data["token"] != SECRET_TOKEN
      halt 403, "Forbidden: Invalid token\n"
    end
  end
end

post "/pacman" do
  # @data is available here
  run_id = @data["run_id"]
  data_artifact_id = @data["data_artifact_id"]
  asset_artifact_id = @data["asset_artifact_id"]
  puts "Received values -> run_id: #{run_id}, data_artifact_id: #{data_artifact_id}, asset_artifact_id: #{asset_artifact_id}"
  "Success: run_id=#{run_id}, data_artifact_id=#{data_artifact_id}, asset_artifact_id=#{asset_artifact_id}\n"
  %x(wget -q -P /servers/jenkins/cache/ 'https://github.com/Ithavollr/PacMan/actions/runs/#{run_id}/artifacts/#{data_artifact_id}')
  %x(wget -q -P /servers/jenkins/cache/ 'https://github.com/Ithavollr/PacMan/actions/runs/#{run_id}/artifacts/#{asset_artifact_id}')
end
