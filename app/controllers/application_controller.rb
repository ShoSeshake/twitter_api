class ApplicationController < ActionController::Base
  # include DeviseTokenAuth::Concerns::SetUserByToken
  # protect_from_forgery

  protected

  def get_response(path, query_params=nil)
    uri = URI.parse("https://api.twitter.com#{path}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme === "https"

    headers = { "Authorization" => "Bearer #{Rails.application.credentials.twitter[:bearer_token]}" }
    req = Net::HTTP::Get.new(uri.path)
    req.initialize_http_header(headers)

    response = http.request(req)
    json_data =  JSON.parse response.body
  end

  def after_sign_in_path_for(resource)
    "/oauth"
  end
end