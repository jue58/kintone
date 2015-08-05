require 'faraday'
require 'faraday_middleware'
require 'base64'
require 'json'
require 'kintone/command/accessor'
require 'kintone/api/guest'
require 'kintone/query'

class Kintone::Api
  BASE_PATH = '/k/v1/'
  COMMAND = '%s.json'
  ACCESSIBLE_COMMAND = [
    :record,
    :records,
    :form,
    :app_acl,
    :record_acl,
    :field_acl,
    :template_space,
    :space,
    :space_body,
    :space_thread,
    :space_members,
    :guests,
    :app,
    :apps,
    :apis,
    :bulk_request,
    :bulk
  ].freeze

  def initialize(domain, user, password)
    token = Base64.encode64("#{user}:#{password}")
    url = "https://#{domain}"
    headers = { 'X-Cybozu-Authorization' => token }
    @connection =
      Faraday.new(url: url, headers: headers) do |builder|
        builder.adapter :net_http
        builder.request :url_encoded
        builder.response :json
      end
  end

  def get_url(command)
    BASE_PATH + (COMMAND % command)
  end

  def guest(space_id)
    Kintone::Api::Guest.new(space_id, self)
  end

  def get(url, params = {})
    response =
      @connection.get do |request|
        request.url url
        request.params = params
      end
    response.body
  end

  def post(url, body)
    response =
      @connection.post do |request|
        request.url url
        request.headers['Content-Type'] = 'application/json'
        request.body = body.to_json
      end
    response.body
  end

  def put(url, body)
    response =
      @connection.put do |request|
        request.url url
        request.headers['Content-Type'] = 'application/json'
        request.body = body.to_json
      end
    response.body
  end

  def delete(url, body = nil)
    response =
      @connection.delete do |request|
        request.url url
        request.headers['Content-Type'] = 'application/json'
        request.body = body.to_json
      end
    response.body
  end

  def method_missing(name, *args)
    if ACCESSIBLE_COMMAND.include?(name)
      CommandAccessor.send(name, self)
    else
      super(name, *args)
    end
  end

  class CommandAccessor
    extend Kintone::Command::Accessor
  end
end
