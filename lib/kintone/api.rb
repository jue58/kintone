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
require 'kintone/command/template_space'
require 'kintone/command/space'
require 'kintone/command/space_body'
require 'kintone/command/space_thread'
require 'kintone/command/space_members'
require 'kintone/command/guests'
require 'kintone/command/app'
require 'kintone/command/apps'
require 'kintone/command/apis'
require 'kintone/command/bulk_request'
require 'kintone/api/guest'
require 'kintone/query'

class Kintone::Api
  BASE_PATH = '/k/v1/'
  COMMAND = '%s.json'

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

  def record
    Kintone::Command::Record.new(self)
  end

  def records
    Kintone::Command::Records.new(self)
  end

  def form
    Kintone::Command::Form.new(self)
  end

  def app_acl
    Kintone::Command::AppAcl.new(self)
  end

  def record_acl
    Kintone::Command::RecordAcl.new(self)
  end

  def field_acl
    Kintone::Command::FieldAcl.new(self)
  end

  def template_space
    Kintone::Command::TemplateSpace.new(self)
  end

  def space
    Kintone::Command::Space.new(self)
  end

  def space_body
    Kintone::Command::SpaceBody.new(self)
  end

  def space_thread
    Kintone::Command::SpaceThread.new(self)
  end

  def space_members
    Kintone::Command::SpaceMembers.new(self)
  end

  def guests
    Kintone::Command::Guests.new(self)
  end

  def app
    Kintone::Command::App.new(self)
  end

  def apps
    Kintone::Command::Apps.new(self)
  end

  def apis
    Kintone::Command::Apis.new(self)
  end

  def bulk
    Kintone::Command::BulkRequest.new(self)
  end
end
