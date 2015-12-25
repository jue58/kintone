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
    :bulk,
    :file
  ].freeze

  def initialize(domain, user, password = nil)
    headers =
      if password # パスワード認証
        { 'X-Cybozu-Authorization' => Base64.encode64("#{user}:#{password}") }
      else # APIトークン認証
        { 'X-Cybozu-API-Token' => user }
      end

    @connection =
      Faraday.new(url: "https://#{domain}", headers: headers) do |builder|
        builder.request :url_encoded
        builder.request :multipart
        builder.response :json, content_type: /\bjson$/
        builder.adapter :net_http
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

  def post_file(url, path, content_type, original_filename)
    response =
      @connection.post do |request|
        request.url url
        request.headers['Content-Type'] = 'multipart/form-data'
        request.body = { file: Faraday::UploadIO.new(
          path, content_type, original_filename,
          'Content-Disposition' => 'form-data') }
      end
    response.body['fileKey']
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
