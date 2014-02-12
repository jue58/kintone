require 'faraday'
require 'faraday_middleware'
require 'base64'
require 'json'
require 'kintone/command/record'
require 'kintone/command/records'
require 'kintone/command/form'

class Kintone::Api
  BASE_PATH = "/k%s/v1/"
  SPACE_PATH = "/guest/%s"

  def initialize(domain, user, password)
    @token = Base64.encode64("#{user}:#{password}")
    @base_path = BASE_PATH % nil
    @connection =
      Faraday.new(:url => "https://#{domain}", :ssl => false) do |builder|
        builder.adapter :net_http
        builder.request :url_encoded
        builder.response :json
        builder.response :logger
      end
  end

  def guest(space)
    space_path = SPACE_PATH % space if space.to_s.match(/^[1-9][0-9]*$/)
    @base_path = BASE_PATH % space_path
    return self
  end

  def get(path, params=nil)
    url = @base_path + path
    response =
      @connection.get do |request|
        request.url url
        request.params = params
        request.headers = {"X-Cybozu-Authorization" => @token}
      end
    return response.body
  end

  def post(path, body)
    url = @base_path + path
    response =
      @connection.post do |request|
        request.url url
        request.headers = {"X-Cybozu-Authorization" => @token, "Content-Type" => "application/json"}
        request.body = body.to_json
      end
    return response.body
  end

  def put(path, body)
    url = @base_path + path
    response =
      @connection.put do |request|
        request.url url
        request.headers = {"X-Cybozu-Authorization" => @token, "Content-Type" => "application/json"}
        request.body = body.to_json
      end
    return response.body
  end

  def delete(path, params=nil)
    url = @base_path + path
    response =
      @connection.delete do |request|
        request.url url
        request.params = params
        request.headers = {"X-Cybozu-Authorization" => @token}
      end
    return response.body
  end

  def record
    Kintone::Command::Record.new(self)
  end

  def records
    Kintone::Command::Records.new(self)
  end

  def form
    Kintone::Command::Form.new(self)
  end
end
