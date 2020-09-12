require 'spec_helper'

describe Kintone::OAuthApi do
  let(:domain) { 'www.example.com' }
  let(:path) { '/k/v1/path' }
  let(:token) { 'access_token' }
  let(:request_verb) { nil }
  let(:default_request_headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:option_request_headers) { nil }
  let(:params) { nil }
  let(:body) { nil }
  let(:response_body) { nil }
  let(:response_status) { 200 }

  let(:add_stub_request) do
    url = "https://#{domain}#{path}"
    url += "?#{URI.encode_www_form(params)}" if params && !params.empty?

    stub_request(request_verb, url) \
      .with do |req|
        req.body = body.to_json if body
        headers = default_request_headers
        headers.merge! option_request_headers if option_request_headers
        req.headers = headers
      end
      .to_return(
        body: response_body.to_json,
        status: response_status,
        headers: { 'Content-type' => 'application/json' }
      )
  end

  context 'specify token argument only' do
    let(:target) { Kintone::OAuthApi.new(domain, token) }

    describe '#get' do
      before(:each) do
        add_stub_request
      end
      let(:request_verb) { :get }
      let(:response_body) { { abc: 'def' } }
      let(:response_status) { 200 }
      subject { target.get(path, params) }

      context 'with some params' do
        let(:params) { { 'p1' => 'abc', 'p2' => 'def' } }
        it { is_expected.to eq 'abc' => 'def' }
      end

      context 'with empty params' do
        let(:params) { {} }
        it { is_expected.to eq 'abc' => 'def' }
      end

      context 'with nil params' do
        let(:params) { nil }
        it { is_expected.to eq 'abc' => 'def' }
      end

      context 'fail to request' do
        let(:response_status) { 500 }
        let(:response_body) { { message: '不正なJSON文字列です。', id: '1505999166-897850006', code: 'CB_IJ01' }.to_json }
        before(:each) do
          add_stub_request
        end
        it { expect { subject }.to raise_error Kintone::KintoneError }
      end
    end

    describe '#post' do
      before(:each) do
        add_stub_request
      end
      let(:request_verb) { :post }
      let(:response_status) { 200 }
      let(:response_body) { { abc: 'def' } }
      let(:params) { nil }
      let(:body) { { p1: 'abc', p2: 'def' } }
      let(:option_headers) { { 'Content-Type' => 'application/json' } }
      subject { target.post(path, body) }

      it { is_expected.to eq 'abc' => 'def' }
    end

    describe '#put' do
      before(:each) do
        add_stub_request
      end
      let(:request_verb) { :put }
      let(:response_status) { 200 }
      let(:response_body) { { abc: 'def' } }
      let(:params) { nil }
      let(:body) { { p1: 'abc', p2: 'def' } }
      let(:option_headers) { { 'Content-Type' => 'application/json' } }
      subject { target.put(path, body) }

      it { is_expected.to eq 'abc' => 'def' }
    end

    describe '#delete' do
      before(:each) do
        add_stub_request
      end
      let(:request_verb) { :delete }
      let(:response_status) { 200 }
      let(:response_body) { { abc: 'def' } }
      let(:params) { nil }
      let(:body) { { p1: 'abc', p2: 'def' } }
      let(:option_headers) { { 'Content-Type' => 'application/json' } }
      subject { target.delete(path, body) }

      it { is_expected.to eq 'abc' => 'def' }
    end

    describe '#refresh!' do
      subject { target.refresh! }
      it { expect { subject }.to raise_error RuntimeError }
    end
  end

  context 'specify token and oauth_options arguments' do
    let(:target) { Kintone::OAuthApi.new(domain, token, oauth_options) }
    let(:oauth_options) do
      {
        client_id: 'client_id',
        client_secret: 'client_secret',
        refresh_token: 'refresh_token',
        expires_at: 1_598_886_000
      }
    end
    let(:access_token_response_body) do
      {
        access_token: 'new_access_token',
        token_type: 'bearer',
        expires_in: 3600,
        scope: 'k:app_record:read k:app_record:write k:app_settings:read k:app_settings:write k:file:read k:file:write'
      }
    end
    describe '#refresh!' do
      before(:each) do
        url = 'https://www.example.com/oauth2/token'
        stub_request(:post, url)\
          .with(
            body: {
              client_id: oauth_options[:client_id],
              client_secret: oauth_options[:client_secret],
              grant_type: 'refresh_token',
              refresh_token: oauth_options[:refresh_token]
            },
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            }
          )
          .to_return(
            body: access_token_response_body.to_json,
            status: 200,
            headers: { 'Content-type' => 'application/json' }
          )
      end
      subject { target.refresh!.token }
      it { is_expected.to eq 'new_access_token' }
    end
  end
end
