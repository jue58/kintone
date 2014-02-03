require 'faraday'
require 'faraday_middleware'
require 'base64'

class Kintone::Api
  def initialize(domain, user, password)
    @token = Base64.encode64("#{user}:#{password}")
    @connection =
      Faraday.new(:url => "https://#{domain}", :ssl => false) do |builder|
        builder.adapter :net_http
        builder.request :url_encoded
        builder.response :json
        builder.response :logger
      end
  end

  def get(path, params=nil)
    response =
      @connection.get do |request|
        request.url path
        request.params = params
        request.headers = {"X-Cybozu-Authorization" => @token}
      end
    return response.body
  end
end
