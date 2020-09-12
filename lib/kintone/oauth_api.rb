require 'oauth2'

class Kintone::OAuthApi < Kintone::Api
  # @return [OAuth2::AccessToken]
  attr_reader :access_token

  # @param [String] domain the kintone's domain (e.g. 'foobar.cybozu.com').
  # @param [String] token the Access Token value.
  # @param [Hash] opts the options to create the Access Token with.
  # @option opts [String] :client_id (nil) the client_id value.
  # @option opts [String] :client_secret (nil) the client_secret value.
  # @option opts [String] :refresh_token (nil) the refresh_token value.
  # @option opts [FixNum, String] :expires_at (nil) the epoch time in seconds in which AccessToken will expire.
  # @yield [builder] The Faraday connection builder
  def initialize(domain, token, opts = {}, &block)
    client_options = {
      site: "https://#{domain}",
      token_url: '/oauth2/token',
      authorize_url: '/oauth2/authorization',
      connection_build: connection_builder(&block)
    }
    client = ::OAuth2::Client.new(opts[:client_id], opts[:client_secret], client_options)
    @access_token = ::OAuth2::AccessToken.new(client, token, refresh_token: opts[:refresh_token], expires_at: opts[:expires_at])
  end

  def get(url, params = {})
    opts = request_options(params: params, headers: nil)
    request(:get, url, opts)
  end

  def post(url, body)
    opts = request_options(body: body)
    request(:post, url, opts)
  end

  def put(url, body)
    opts = request_options(body: body)
    request(:put, url, opts)
  end

  def delete(url, body = nil)
    opts = request_options(body: body)
    request(:delete, url, opts)
  end

  def refresh!
    @access_token = @access_token.refresh!
  end

  private

  def connection_builder(&block)
    lambda { |con|
      con.request :url_encoded
      con.request :multipart
      # NOTE: comment out for avoiding following bug at OAuth2 v1.4.4.
      #       In 2.x the bug will be fixed.
      #       refer to https://github.com/oauth-xx/oauth2/pull/380
      # con.response :json, content_type: /\bjson$/
      block.call(con) if block_given?
    }
  end

  def request(verb, url, opts)
    response = @access_token.request(verb, url, opts)
    validate_response(response)
  rescue OAuth2::Error => e
    response = e.response
    raise Kintone::KintoneError.new(response.body, response.status)
  end

  def validate_response(response, expected_status = 200)
    if response.status != expected_status
      raise Kintone::KintoneError.new(response.body, response.status)
    end

    JSON.parse(response.body)
  end

  def request_options(params: nil, body: nil, headers: default_headers)
    opts = {}
    opts[:headers] = headers
    opts[:params] = params if params
    opts[:body] = body.to_json if body
    opts
  end

  def default_headers
    { 'Content-Type' => 'application/json' }
  end
end
