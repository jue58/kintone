require 'faraday'
require 'faraday_middleware'
require 'base64'
require 'json'
require 'kintone/command/record'
require 'kintone/command/records'
require 'kintone/command/form'
require 'kintone/command/app_acl'
require 'kintone/command/record_acl'
require 'kintone/command/field_acl'
require 'kintone/api/guest'

class Kintone::Api
  BASE_PATH = "/k/v1/"
  COMMAND = "%s.json"

  def initialize(domain, user, password)
    token = Base64.encode64("#{user}:#{password}")
    @connection =
      Faraday.new(:url => "https://#{domain}",
                  :headers => {"X-Cybozu-Authorization" => token},
                  :ssl => false) do |builder|
        builder.adapter :net_http
        builder.request :url_encoded
        builder.response :json
        builder.response :logger
      end
  end

  def get_url(command)
    return BASE_PATH + (COMMAND % command)
  end

  def guest(space_id)
    return Kintone::Api::Guest.new(space_id, self)
  end

  def get(url, params=nil)
    response =
      @connection.get do |request|
        request.url url
        request.params = params
      end
    return response.body
  end

  def post(url, body)
    response =
      @connection.post do |request|
        request.url url
        request.headers["Content-Type"] = "application/json"
        request.body = body.to_json
      end
    return response.body
  end

  def put(url, body)
    response =
      @connection.put do |request|
        request.url url
        request.headers["Content-Type"] = "application/json"
        request.body = body.to_json
      end
    return response.body
  end

  def delete(url, params=nil)
    response =
      @connection.delete do |request|
        request.url url
        request.params = params
      end
    return response.body
  end

  def record
    return Kintone::Command::Record.new(self)
  end

  def records
    return Kintone::Command::Records.new(self)
  end

  def form
    return Kintone::Command::Form.new(self)
  end

  def app_acl
    return Kintone::Command::AppAcl.new(self)
  end

  def record_acl
    return Kintone::Command::RecordAcl.new(self)
  end

  def field_acl
    return Kintone::Command::FieldAcl.new(self)
  end
end
